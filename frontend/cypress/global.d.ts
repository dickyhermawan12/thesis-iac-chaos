declare namespace Cypress {
  interface Chainable {
    /**
     * Logs-in user by using UI
     */
    login(email: string, password: string): Chainable<void>
    /**
     * Seeds post by using API
     */
    seedPost(): Chainable<void>
  }
}