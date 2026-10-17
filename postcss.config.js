// Vite が読み込む。build:css (postcss-cli) は --use=autoprefixer を指定するためこの設定は使わない
module.exports = {
  plugins: [require('autoprefixer')]
}
