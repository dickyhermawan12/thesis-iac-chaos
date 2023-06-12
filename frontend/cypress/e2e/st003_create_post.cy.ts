Cypress.on('test:after:run', (attributes) => {
  /* eslint-disable no-console */
  console.log('Test "%s" has finished in %dms',
    attributes.title, attributes.duration)
})

describe('create post', () => {
  before(() => {
    cy.login('johndoe@test.mail', 'johndoepass')
  })

  it('create new post', () => {
    cy.visit('/')
    cy.get('#nav').contains('post').click()
    cy.get('#create-post').click()
    cy.get('#posttitle').type('Sample Post').should('have.value', 'Sample Post')
    cy.get('#postbody').type('This is a sample body of a post').should('have.value', 'This is a sample body of a post')
    // intercept the POST request after clicking submit button
    cy.intercept('POST', '**/posts').as('create')
    cy.get('#submit').click()
    // wait for the POST request to finish, this is to intercept 307 redirect
    cy.wait('@create').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(307)
    })
    cy.wait('@create').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(201)
      expect(response && response.body).to.have.property('title', 'Sample Post')
      expect(response && response.body).to.have.property('body', 'This is a sample body of a post')
    })
  })
})