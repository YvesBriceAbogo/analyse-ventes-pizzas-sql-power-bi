# Documentation du jeu de données — Ventes de Pizzas (`pizza_sales.csv`)

## 1. Vue d'ensemble

- **Fichier source :** `pizza_sales.csv`
- **Période couverte :** du 1ᵉʳ janvier 2015 au 31 décembre 2015
- **Nombre de lignes (lignes de commande) :** 48 620
- **Nombre de commandes uniques (`order_id`) :** 21 350
- **Quantité totale de pizzas vendues (`quantity`) :** 49 574
- **Origine :** Jeu de données public disponible en ligne (source exacte non confirmée).
- **Usage :** Pédagogique et démonstratif dans le cadre d'un portfolio de Business Intelligence.

> **Avertissement sur la licence :** La licence MIT de ce dépôt couvre exclusivement les scripts SQL, Power Query, DAX et la documentation. Elle ne s'applique pas au fichier `pizza_sales.csv`.

---

## 2. Dictionnaire des données

| Colonne | Type SQL | Description | Exemple |
|---|---|---|---|
| `pizza_id` | `INT` | Identifiant unique de la ligne de vente | `1` |
| `order_id` | `INT` | Identifiant de la commande (une commande peut contenir plusieurs lignes) | `1` |
| `pizza_name_id` | `VARCHAR(50)` | Code court identifiant la recette et la taille | `hawaiian_m` |
| `quantity` | `INT` | Quantité commandée pour cette référence sur la ligne | `1` |
| `order_date` | `DATE` | Date de la commande | `2015-01-01` |
| `order_time` | `TIME` | Heure d'enregistrement de la commande | `11:38:36` |
| `unit_price` | `DECIMAL(10,2)` | Prix unitaire de la pizza | `13.25` |
| `total_price` | `DECIMAL(10,2)` | Montant total de la ligne (`quantity * unit_price`) | `13.25` |
| `pizza_size` | `VARCHAR(10)` | Code taille d'origine (`S`, `M`, `L`, `XL`, `XXL`) | `M` |
| `pizza_category` | `VARCHAR(50)` | Catégorie de la pizza (`Classic`, `Supreme`, `Chicken`, `Veggie`) | `Classic` |
| `pizza_ingredients` | `VARCHAR(255)` | Liste des ingrédients composant la pizza | `Sliced Ham, Pineapple, Mozzarella Cheese` |
| `pizza_name` | `VARCHAR(100)` | Nom commercial complet de la pizza | `The Hawaiian Pizza` |
