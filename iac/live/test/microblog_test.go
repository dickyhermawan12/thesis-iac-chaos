package test

import (
	"fmt"
	"io/ioutil"
	"os"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"golang.org/x/crypto/ssh"
)

func TestEndToEndDeploymentScenario(t *testing.T) {
	t.Parallel()

	fixtureFolder := "../"
	sshKeyPath := os.Getenv("TEST_SSH_KEY_PATH")

	if sshKeyPath == "" {
		t.Fatalf("TEST_SSH_KEY_PATH environment variable cannot be empty.")
	}

	// User Terratest to deploy the infrastructure
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := &terraform.Options{
			// Indicate the directory that contains the Terraform configuration to deploy
			TerraformDir: fixtureFolder,
		}

		// Save options for later test stages
		test_structure.SaveTerraformOptions(t, fixtureFolder, terraformOptions)

		// Triggers the terraform init and terraform apply command
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		// run validation checks here
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)

		vmJumpboxPublicIP := terraform.Output(t, terraformOptions, "jumpbox_public_ip")
		vmWebServerPrivateIP := terraform.Output(t, terraformOptions, "vm_linux_2_private_ip_address")

		// it takes some time for Azure to assign the public IP address so it's not available in Terraform output after the first apply
		attemptsCount := 0
		for vmJumpboxPublicIP == "" && attemptsCount < 5 {
			// add wait time to let Azure assign the public IP address and apply the configuration again, to refresh state.
			time.Sleep(30 * time.Second)
			terraform.Apply(t, terraformOptions)
			vmJumpboxPublicIP = terraform.Output(t, terraformOptions, "jumpbox_public_ip")
			attemptsCount++
		}

		if vmJumpboxPublicIP == "" {
			t.Fatal("Cannot retrieve the public IP address value for the linux vm 1.")
		}

		key, err := ioutil.ReadFile(sshKeyPath)
		if err != nil {
			t.Fatalf("Unable to read private key: %v", err)
		}

		signer, err := ssh.ParsePrivateKey(key)
		if err != nil {
			t.Fatalf("Unable to parse private key: %v", err)
		}

		sshConfig := &ssh.ClientConfig{
			User: "dicky",
			Auth: []ssh.AuthMethod{
				ssh.PublicKeys(signer),
			},
			HostKeyCallback: ssh.InsecureIgnoreHostKey(),
		}

		sshConnection, err := ssh.Dial("tcp", fmt.Sprintf("%s:22", vmJumpboxPublicIP), sshConfig)
		if err != nil {
			t.Fatalf("Cannot establish SSH connection to jumpbox public IP address: %v", err)
		}

		defer sshConnection.Close()
		sshSession, err := sshConnection.NewSession()
		if err != nil {
			t.Fatalf("Cannot create SSH session to jumpbox public IP address: %v", err)
		}

		defer sshSession.Close()
	})

	// When the test is completed, teardown the infrastructure by calling terraform destroy
	test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
		terraform.Destroy(t, terraformOptions)
	})
}

func TestTerraformComputegroup(t *testing.T) {
	t.Parallel()

	fixtureFolder := "./fixture"

	// Deploy the example
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(t, fixtureFolder)

		// Save the options so later test stages can use them
		test_structure.SaveTerraformOptions(t, fixtureFolder, terraformOptions)

		// This will init and apply the resources and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	// Check whether the compute group allows public HTTP request through load balancer
	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)

		// Make sure we can send HTTP request to the server
		testHTTPToServer(t, terraformOptions)
	})

	// At the end of the test, clean up any resources that were created
	test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
		terraform.Destroy(t, terraformOptions)
	})

}

func configureTerraformOptions(t *testing.T, fixtureFolder string) *terraform.Options {

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: fixtureFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{},
	}

	return terraformOptions
}

func testHTTPToServer(t *testing.T, terraformOptions *terraform.Options) {
	// Get the value of an output variable
	publicIP := terraform.Output(t, terraformOptions, "public_ip_address")

	// It can take a minute or so for the web server to boot up, so retry a few times
	maxRetries := 15
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("HTTP to %s", publicIP)

	// Verify that we can send HTTP request
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		// Get HTTP response from server
		response, err1 := getHTTPResponse(t, publicIP)
		if err1 != nil {
			return "", err1
		}

		// Check whether the content of HTTP response contains nginx
		defer response.Body.Close()
		substring := "nginx"
		err2 := checkContents(t, response, substring)
		if err2 != nil {
			return "", err2
		}
		fmt.Printf("HTTP found %s.\n", substring)

		return "", nil
	})
}
