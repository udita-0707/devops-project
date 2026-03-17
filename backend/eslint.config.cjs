const js = require("@eslint/js");

module.exports = [
  js.configs.recommended,

  // Node.js environment
  {
    files: ["**/*.js"],
    languageOptions: {
      globals: {
        require: "readonly",
        module: "readonly",
        process: "readonly",
        console: "readonly"
      }
    }
  },

  // Jest environment (for test files)
  {
    files: ["tests/**/*.js"],
    languageOptions: {
      globals: {
        test: "readonly",
        expect: "readonly",
        describe: "readonly"
      }
    }
  },

  {
    rules: {
      "no-unused-vars": "warn",
      "no-undef": "off"
    }
  }
];