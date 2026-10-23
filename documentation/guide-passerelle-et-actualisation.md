# Guide de publication, Passerelle de données et Actualisation planifiée

## 1. Architecture de déploiement

Le rapport Power BI est publié sur **Power BI Service** et connecté à la source de données locale via une **Passerelle de données locale (On-premises data gateway — mode standard)**.

```text
Fichier CSV source (pizza_sales.csv)
        │
        ▼
Base de données MS SQL Server (Localhost / Base : Pizzas)
        │
        ▼
Passerelle de données locale (Mode Standard)
        │
        ▼
Power BI Service (Modèle sémantique & Rapport publié)
        │
        ▼
Actualisation planifiée : 11 h 30 et 17 h 00 (UTC+02:00 — Heure d'Afrique du Sud)
