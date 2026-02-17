import js from '@eslint/js'

export default [
  {
    ignores: ['.nuxt/**', '.output/**', 'node_modules/**', 'dist/**', 'coverage/**']
  },
  js.configs.recommended,
  {
    files: ['**/*.{js,mjs}'],
    rules: {
      'no-console': 'off',
      'no-undef': 'off'
    }
  }
]
