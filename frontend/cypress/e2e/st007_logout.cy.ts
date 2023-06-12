Cypress.on('test:after:run', (attributes) => {
  /* eslint-disable no-console */
  console.log('Test "%s" has finished in %dms',
    attributes.title, attributes.duration)
})

describe('logout', () => {
  before(() => {
    cy.login('johndoe@test.mail', 'johndoepass')
  })

  it('logout from session', () => {
    cy.visit('/')
    cy.get('#nav').contains('profile').click()
    cy.get('#signout').click()
    cy.get('#nav').contains('login').should('exist')
  })
})