module.exports = {
  extends: ['stylelint-config-standard', 'stylelint-config-recommended-vue'],
  overrides: [
    {
      files: ['**/*.vue'],
      customSyntax: 'postcss-html'
    }
  ],
  ignoreFiles: ['.nuxt/**', '.output/**', 'node_modules/**', 'dist/**', 'coverage/**'],
  rules: {
    'selector-class-pattern': null,
    'selector-id-pattern': null,
    'import-notation': null,
    'color-hex-length': null,
    'color-function-alias-notation': null,
    'color-function-notation': null,
    'alpha-value-notation': null,
    'media-feature-range-notation': null
  }
}
