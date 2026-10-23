# Limites méthodologiques et pistes d'évolution

## 1. Limites du jeu de données

- **Périmètre temporel :** Le jeu de données couvre exclusivement l'année civile 2015 (du 1ᵉʳ janvier au 31 décembre 2015). L'absence d'historique sur 2014 ne permet pas de calculer des variations annuelles (YoY %).
- **Absence de coûts d'achat (COGS) :** Les données fournissent le chiffre d'affaires brut (`total_price`), mais pas le coût matières des ingrédients. L'analyse porte donc sur le chiffre d'affaires et les volumes, et non sur la marge brute.
- **Origine et devise :** Le jeu de données provient d'une source publique en ligne non identifiée avec certitude. Les montants sont exprimés en unités monétaires (vraisemblablement USD).

---

## 2. Architecture du modèle de données

- **Table unique (`pizzas_sales`) :** Compte tenu de la structure du fichier plat d'origine et de l'absence de tables de dimensions externes (clients, magasins), le modèle repose sur une table unique enrichie dans Power Query.
- **Évolution recommandée en production :** Dans un environnement décisionnel d'entreprise multi-années, il est recommandé de séparer cette table en un **schéma en étoile** :
  - Une table de faits (`Fact_Pizza_Sales`) ;
  - Une dimension Calendrier dédiée (`Dim_Date`) ;
  - Une dimension Produits (`Dim_Pizza` contenant nom, taille, catégorie, ingrédients et prix catalogue).
