/*=============================================================================
  PROJET  : Analyse Commerciale et Financière des Ventes de Pizzas
  AUTEUR  : Brice Abogo
  REQUÊTE : pizzas_sales
  OBJET   : Extraction depuis SQL Server (ou CSV), enrichissement temporel
            indépendant des paramètres régionaux et normalisation des tailles.
=============================================================================*/

let
    // 1. Paramètres de connexion à la base de données SQL Server locale
    ServerName = "Localhost",
    DatabaseName = "Pizzas",
    Source = Sql.Database(ServerName, DatabaseName),
    dbo_pizzas_sales = Source{[Schema="dbo", Item="pizzas_sales"]}[Data],

    // 2. Dictionnaires de correspondance (Tailles et Abréviations des mois français)
    SizeMapping = [
        S   = "Regular",
        M   = "Medium",
        L   = "Large",
        XL  = "X-Large",
        XXL = "XX-Large"
    ],
    MonthShortMapping = [
        #"janvier"   = "JANV",
        #"février"   = "FEV",
        #"mars"      = "MARS",
        #"avril"     = "AVR",
        #"mai"       = "MAI",
        #"juin"      = "JUIN",
        #"juillet"   = "JUIL",
        #"août"      = "AOÛT",
        #"septembre" = "SEPT",
        #"octobre"   = "OCT",
        #"novembre"  = "NOV",
        #"décembre"  = "DEC"
    ],

    // 3. Normalisation du libellé de la taille des pizzas
    AddedPizzaSize = Table.AddColumn(
        dbo_pizzas_sales,
        "Pizza Size",
        each Record.FieldOrDefault(SizeMapping, [pizza_size], "XX-Large"),
        type text
    ),
    RemovedRawSize = Table.RemoveColumns(AddedPizzaSize, {"pizza_size"}),

    // 4. Enrichissement temporel : Jours de la semaine (Culture explicite fr-FR)
    InsertedDayName = Table.AddColumn(
        RemovedRawSize,
        "Day Name",
        each Date.DayOfWeekName([order_date], "fr-FR"),
        type text
    ),
    InsertedOrderDay = Table.AddColumn(
        InsertedDayName,
        "Order Day",
        each Text.Upper(Text.Start([Day Name], 3)),
        type text
    ),
    InsertedDayOfWeek = Table.AddColumn(
        InsertedOrderDay,
        "Day of Week",
        each Date.DayOfWeek([order_date], Day.Monday),
        Int64.Type
    ),

    // 5. Enrichissement temporel : Mois (Culture explicite fr-FR)
    InsertedMonthName = Table.AddColumn(
        InsertedDayOfWeek,
        "Month Name",
        each Date.MonthName([order_date], "fr-FR"),
        type text
    ),
    InsertedOrderMonth = Table.AddColumn(
        InsertedMonthName,
        "Order Month",
        each Record.FieldOrDefault(
            MonthShortMapping,
            Text.Lower([Month Name]),
            Text.Upper(Text.Start([Month Name], 4))
        ),
        type text
    ),
    InsertedMonthNum = Table.AddColumn(
        InsertedOrderMonth,
        "Month_Num",
        each Date.Month([order_date]),
        Int64.Type
    )
in
    InsertedMonthNum
