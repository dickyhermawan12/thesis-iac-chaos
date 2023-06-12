Cypress.Commands.add('login', (email, password) => {
  cy.session([email, password], () => {
    cy.visit('/')
    cy.get('#nav').contains('login').click()
    cy.get('#email').type('johndoe@test.mail').should('have.value', 'johndoe@test.mail')
    cy.get('#password').type('johndoepass')
    cy.intercept('GET', '**/session').as('session')
    cy.get('#submit').click()
    cy.wait('@session').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(200)
      expect(response && response.body).to.have.property('user').to.be.an('object').to.have.property('id')
      expect(response && response.body).to.have.property('accessToken')
    })
  })
})

Cypress.Commands.add('seedPost', () => {
  cy.request('/api/test')
})