# Historique des versions (Changelog)

Toutes les modifications notables apportées à ce projet sont documentées dans ce fichier.

## [v1.0.0] - Publication initiale

### Ajouté
- **SQL Server (`sql/analyse-ventes-pizzas.sql`) :** Script T-SQL complet de typage des données, contrôle du schéma et requêtes de validation des KPIs, tendances et palmarès Top/Bottom 5.
- **Power Query (`power-query/transformation-pizzas-sales.pq`) :** Script M optimisé avec gestion explicite de la culture (`fr-FR`), début de semaine au lundi (`Day.Monday`) et table de correspondance des tailles de pizzas.
- **DAX (`dax/mesures-dax.dax`) :** Mesures de base et ratios de performance sécurisés via `DIVIDE()`.
- **Power BI (`power-bi/analyse-ventes-pizzas.pbix`) :** Tableau de bord interactif en 2 pages (*Home* et *Best/Worst Sellers*) et export PDF.
- **Power BI Service :** Mise en place d'une passerelle locale (mode standard) avec actualisation planifiée à 11 h 30 et 17 h 00 (heure d'Afrique du Sud).
