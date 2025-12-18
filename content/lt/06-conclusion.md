+++
date = '2025-12-18T12:06:00+09:00'
draft = false
title = '6. まとめ・結論'
description = '用途別おすすめと結論'
tags = ['Hugo', 'SSG', 'CDN', 'LT']
weight = 6
+++

**時間: 1分**

---

## 用途別おすすめ

| ユースケース | おすすめ |
|-------------|---------|
| 個人ブログ | **Cloudflare Pages** / GitHub Pages |
| ドキュメントサイト | **Cloudflare Pages** |
| 既存AWS環境あり | **S3 + CloudFront** |
| 細かい制御が必要 | **S3 + CloudFront** |
| とにかく簡単に | **GitHub Pages** |

---

## 結論

> **「静的でいいならSSG + CDN、安くて速い」**

---

## 3つのポイント

1. 動的機能が不要なら、**SSGで十分**
2. CDNは**無料で使える**時代（Cloudflare、GitHub）
3. 「WordPressじゃなきゃダメ」は**思い込みかも**

---

## 参考リンク

- [Hugo公式サイト](https://gohugo.io/)
- [Cloudflare Pages](https://pages.cloudflare.com/)
- [GitHub Pages](https://pages.github.com/)
- [AWS CloudFront](https://aws.amazon.com/cloudfront/)

---

## Q&A

ご質問があればどうぞ！

---

**最初に戻る**: [目次]({{< ref "/lt" >}})

