import Foundation
import HTML
import Saga
import SagaPathKit
import SagaSwimRenderer

func baseHtml(title pageTitle: String, @NodeBuilder children: () -> NodeConvertible) -> Node {
  html(lang: "en-US") {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      title { pageTitle }
      link(href: Saga.hashed("/static/style.css"), rel: "stylesheet")
      meta(content: SiteMetadata.description, name: "description")
      meta(content: pageTitle, customAttributes: ["property": "og:title"])
      meta(content: SiteMetadata.description, customAttributes: ["property": "og:description"])
      meta(content: "website", customAttributes: ["property": "og:type"])
      meta(content: SiteMetadata.url.absoluteString, customAttributes: ["property": "og:url"])
      meta(content: "\(SiteMetadata.url.absoluteString)/static/assets/app-icon.png", customAttributes: ["property": "og:image"])
      meta(content: "summary_large_image", name: "twitter:card")
    }
    body {
      header {
        nav {
          a(class: "site-title", href: "/") { SiteMetadata.name }
          a(class: "nav-cta", href: "https://testflight.apple.com/join/NRRmBQjP") { "Try it on the App Store" }
        }
      }
      main {
        children()
      }
      footer {
        p { "© 2026 \(SiteMetadata.author). All rights reserved." }
      }
    }
  }
}

func renderArticle(context: ItemRenderingContext<ArticleMetadata>) -> Node {
  baseHtml(title: context.item.title) {
    article {
      h1 { context.item.title }
      ul(class: "tags") {
        context.item.metadata.tags.map { tag in
          li {
            a(href: "/articles/tag/\(tag.slugified)/") { tag }
          }
        }
      }
      Node.raw(context.item.body)
    }
  }
}

func renderArticles(context: ItemsRenderingContext<ArticleMetadata>) -> Node {
  baseHtml(title: "Articles") {
    h1 { "Articles" }
    context.items.map { article in
      div(class: "article-card") {
        h2 {
          a(href: article.url) { article.title }
        }
        if let summary = article.metadata.summary {
          p { summary }
        }
      }
    }
  }
}

func renderTag<T>(context: PartitionedRenderingContext<T, ArticleMetadata>) -> Node {
  baseHtml(title: "Articles tagged \(context.key)") {
    h1 { "Articles tagged \(context.key)" }
    context.items.map { article in
      div(class: "article-card") {
        h2 {
          a(href: article.url) { article.title }
        }
      }
    }
  }
}

func renderPage(context: ItemRenderingContext<EmptyMetadata>) -> Node {
  baseHtml(title: context.item.title) {
    Node.raw(context.item.body)
  }
}
