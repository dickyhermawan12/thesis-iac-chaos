Cypress.on('test:after:run', (attributes) => {
  /* eslint-disable no-console */
  console.log('Test "%s" has finished in %dms',
    attributes.title, attributes.duration)
})

describe('register', () => {
  before(() => {
    cy.request('DELETE', 'https://iac-thesis-microblog.australiacentral.cloudapp.azure.com/api/users/')
    cy.visit('/')
    cy.get('#nav').contains('register').click()
  })

  it('register new user', () => {
    cy.get('#username').type('John Doe').should('have.value', 'John Doe')
    cy.get('#email').type('johndoe@test.mail').should('have.value', 'johndoe@test.mail')
    cy.get('#password').type('johndoepass')
    // intercept the POST request after clicking submit button
    cy.intercept('POST', '**/users').as('register')
    cy.get('#submit').click()
    // wait for the POST request to finish, this is to intercept 307 redirect
    cy.wait('@register').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(307)
    })
    cy.wait('@register').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(201)
      expect(request.body).to.have.property('username', 'John Doe')
      expect(request.body).to.have.property('password', 'johndoepass')
    })
  })

  it('check db', () => {
    cy.request('https://iac-thesis-microblog.australiacentral.cloudapp.azure.com/api/users/email?email=johndoe@test.mail')
      .should((response) => {
        expect(response.status).to.eq(200)
        expect(response.body).to.have.property('username', 'John Doe')
        expect(response.body).to.have.property('email', 'johndoe@test.mail')
      })
  })
})