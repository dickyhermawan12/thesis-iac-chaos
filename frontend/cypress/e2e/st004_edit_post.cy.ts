Cypress.on('test:after:run', (attributes) => {
  /* eslint-disable no-console */
  console.log('Test "%s" has finished in %dms',
    attributes.title, attributes.duration)
})

describe('edit post', () => {
  before(() => {
    cy.login('johndoe@test.mail', 'johndoepass')
    cy.seedPost()
  })

  it('edit existing post', () => {
    cy.visit('/')
    cy.get('#nav').contains('post').click()
    cy.get('.post-title').contains('Test Post').click()
    cy.get('#edit-post').click()
    // fill in the form
    cy.get('#posttitle').clear().type('Edited Sample Post').should('have.value', 'Edited Sample Post')
    cy.get('#postbody').clear().type('This is a sample body of a post that is edited').should('have.value', 'This is a sample body of a post that is edited')
    // intercept the PUT request after clicking submit button
    cy.intercept('PUT', '**/posts/*').as('edit')
    cy.get('#submit').click()
    cy.wait('@edit').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(200)
      expect(response && response.body).to.have.property('title', 'Edited Sample Post')
      expect(response && response.body).to.have.property('body', 'This is a sample body of a post that is edited')
    })
  })
})