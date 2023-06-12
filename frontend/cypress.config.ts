import { defineConfig } from "cypress";

export default defineConfig({
  e2e: {
    baseUrl: process.env.CYPRESS_BASE_URL || "http://localhost:3000",
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
