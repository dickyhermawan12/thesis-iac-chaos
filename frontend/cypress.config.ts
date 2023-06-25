import { defineConfig } from "cypress";

export default defineConfig({
  e2e: {
    baseUrl: "https://iac-thesis-microblog.australiacentral.cloudapp.azure.com",
    experimentalRunAllSpecs: true,
    setupNodeEvents(on, config) {
      // implement node event listeners here
      on("task", {
        testTimings(testAttributes) {
          console.log('Test "%s" has finished in %dms',
            testAttributes.title, testAttributes.duration)
          return null;
        }
      });
    },
  },
});
