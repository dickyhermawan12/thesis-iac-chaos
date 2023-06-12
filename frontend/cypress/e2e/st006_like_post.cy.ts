Cypress.on('test:after:run', (attributes) => {
  /* eslint-disable no-console */
  console.log('Test "%s" has finished in %dms',
    attributes.title, attributes.duration)
})

describe('like post', () => {
  before(() => {
    cy.login('johndoe@test.mail', 'johndoepass')
    cy.seedPost()
  })

  it('like existing post', () => {
    cy.visit('/')
    cy.get('#nav').contains('post').click()
    cy.get('.post-title').contains('Test Post').click()
    // intercept for like request
    cy.intercept('POST', '**/like').as('like')
    cy.get('#like-btn').click()
    cy.wait('@like').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(307)
    })
    cy.wait('@like').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(201)
      expect(response && response.body).to.have.property('message', 'successfully added like')
      expect(response && response.body).to.have.property('dir', 1)
    })
    cy.get('#like-count').should('have.text', '1')
    // intercept for unlike request
    cy.get('#like-btn').click()
    cy.wait('@like').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(307)
    })
    cy.wait('@like').should(({ request, response }) => {
      expect(response?.statusCode).to.eq(201)
      expect(response && response.body).to.have.property('message', 'successfully deleted like')
      expect(response && response.body).to.have.property('dir', 0)
    })
    cy.get('#like-count').should('have.text', '0')
  })
})