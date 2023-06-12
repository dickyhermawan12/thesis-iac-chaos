Cypress.on('test:after:run', (attributes) => {
  /* eslint-disable no-console */
  console.log('Test "%s" has finished in %dms',
    attributes.title, attributes.duration)
})

describe('login', () => {
  before(() => {
    cy.visit('/')
    cy.get('#nav').contains('login').click()
  })

  it('login to account', () => {
    cy.get('#email').type('johndoe@test.mail').should('have.value', 'johndoe@test.mail')
    cy.get('#password').type('johndoepass')
    // intercept the GET request after clicking submit button
    cy.intercept('GET', '**/session').as('session')
    cy.get('#submit').click()
    cy.wait('@session').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(200)
      expect(response && response.body).to.have.property('user').to.be.an('object').to.have.property('id')
      expect(response && response.body).to.have.property('accessToken')
    })
  })
})