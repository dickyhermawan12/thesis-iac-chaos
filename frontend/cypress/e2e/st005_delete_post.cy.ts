Cypress.on('test:after:run', (attributes) => {
  /* eslint-disable no-console */
  console.log('Test "%s" has finished in %dms',
    attributes.title, attributes.duration)
})

describe('delete post', () => {
  before(() => {
    cy.login('johndoe@test.mail', 'johndoepass')
    cy.seedPost()
  })

  it('delete existing post', () => {
    cy.visit('/')
    cy.get('#nav').contains('post').click()
    cy.get('.post-title').contains('Test Post').click()
    // intercept the DELETE request after clicking delete button
    cy.intercept('DELETE', '**/posts/*').as('delete')
    cy.get('#delete-post').click()
    cy.wait('@delete').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(204)
    })
  })
})