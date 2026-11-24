/* ============================================================================
   MealPlanning Version 2.0 – Example Queries
   ============================================================================ */

USE MealPlanning;

/* 1. Meal plan for a particular day */
SELECT
    PlanDate,
    MealType,
    RecipeName,
    CookbookName
FROM MealPlan
WHERE PlanDate = '2026-11-23'
ORDER BY FIELD(MealType, 'Breakfast', 'Lunch', 'Dinner');


/* 2. Meal plan for a particular week */
SELECT
    PlanDate,
    MealType,
    RecipeName,
    CookbookName
FROM MealPlan
WHERE PlanDate BETWEEN '2026-11-23' AND '2026-11-29'
ORDER BY PlanDate, FIELD(MealType, 'Breakfast', 'Lunch', 'Dinner');


/* 3. Meal plan for a particular month */
SELECT
    PlanDate,
    MealType,
    RecipeName,
    CookbookName
FROM MealPlan
WHERE YEAR(PlanDate) = 2026 AND MONTH(PlanDate) = 11
ORDER BY PlanDate, FIELD(MealType, 'Breakfast', 'Lunch', 'Dinner');


/* 4. Dietary restrictions of each family member */
SELECT
    F.FirstName,
    F.LastName,
    D.Restriction
FROM FamilyMember F
JOIN DietaryRestriction D ON F.MemberId = D.MemberId
ORDER BY F.LastName, F.FirstName, D.Restriction;


/* 5. Food allergies of each family member */
SELECT
    F.FirstName,
    F.LastName,
    A.Allergen
FROM FamilyMember F
JOIN Allergy A ON F.MemberId = A.MemberId
ORDER BY F.LastName, F.FirstName, A.Allergen;


/* 6. All available lunches ordered by carb content (ascending) */
SELECT
    MP.RecipeName,
    MP.CookbookName,
    N.Carbs
FROM MealPlan MP
JOIN Nutrition N
    ON MP.RecipeName = N.RecipeName
   AND MP.CookbookName = N.CookbookName
WHERE MP.MealType = 'Lunch'
ORDER BY N.Carbs ASC;


/* 7. All dinners under 600 calories */
SELECT
    MP.RecipeName,
    MP.CookbookName,
    N.Calories
FROM MealPlan MP
JOIN Nutrition N
    ON MP.RecipeName = N.RecipeName
   AND MP.CookbookName = N.CookbookName
WHERE MP.MealType = 'Dinner'
  AND N.Calories < 600
ORDER BY N.Calories;


/* 8. Total nutritional information for one family member’s entire day
      (using Michael on 2026-11-23 as the example) */
SELECT
    F.FirstName,
    F.LastName,
    MP.PlanDate,
    SUM(N.Calories)  AS TotalCalories,
    SUM(N.TotalFat)  AS TotalFat,
    SUM(N.Sodium)    AS TotalSodium,
    SUM(N.Carbs)     AS TotalCarbs,
    SUM(N.Protein)   AS TotalProtein
FROM FamilyMember F
CROSS JOIN MealPlan MP
JOIN Nutrition N
    ON MP.RecipeName = N.RecipeName
   AND MP.CookbookName = N.CookbookName
WHERE F.FirstName = 'Michael'
  AND F.LastName = 'Thomas'
  AND MP.PlanDate = '2026-11-23'
GROUP BY F.FirstName, F.LastName, MP.PlanDate;


/* 9. All breakfasts that a particular member is not allergic to
      (example: Olivia – allergic to Tree Nuts) */
SELECT DISTINCT
    MP.RecipeName,
    MP.CookbookName
FROM MealPlan MP
WHERE MP.MealType = 'Breakfast'
  AND MP.RecipeName NOT IN (
        -- recipes that contain an ingredient the member is allergic to
        -- (simplified: we treat the Allergen string as matching IngredientName)
        SELECT M.RecipeName
        FROM Meal M
        JOIN Ingredients I ON M.IngredientId = I.Id
        JOIN Allergy A ON A.Allergen = I.IngredientName
        JOIN FamilyMember F ON A.MemberId = F.MemberId
        WHERE F.FirstName = 'Olivia' AND F.LastName = 'Thomas'
  )
ORDER BY MP.RecipeName;


/* 10. All dinners that a particular member is allergic to
       (example: Jennifer – allergic to Dairy and Shellfish) */
SELECT DISTINCT
    MP.RecipeName,
    MP.CookbookName
FROM MealPlan MP
JOIN Meal M
    ON MP.RecipeName = M.RecipeName
   AND MP.CookbookName = M.CookbookName
JOIN Ingredients I ON M.IngredientId = I.Id
JOIN Allergy A ON A.Allergen = I.IngredientName
JOIN FamilyMember F ON A.MemberId = F.MemberId
WHERE MP.MealType = 'Dinner'
  AND F.FirstName = 'Jennifer'
  AND F.LastName = 'Thomas'
ORDER BY MP.RecipeName;
