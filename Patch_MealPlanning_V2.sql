/* ============================================================================
   MealPlanning Database - Version 2.0 Patch
   Safe to run against an existing Version 1.0 database.
   Does not drop data.
   ============================================================================ */

USE MealPlanning;

-- --------------------------------------------------------------------------
-- 1. Fix Recipe primary key so the same recipe name can exist in
--    more than one cookbook.
--    Current PK is (RecipeName). New PK will be (RecipeName, CookbookName).
-- --------------------------------------------------------------------------

-- Meal currently references Recipe(RecipeName). Drop that FK first.
ALTER TABLE Meal
    DROP FOREIGN KEY Meal_ibfk_1;

-- Change the primary key on Recipe
ALTER TABLE Recipe
    DROP PRIMARY KEY,
    ADD PRIMARY KEY (RecipeName, CookbookName);

-- Re-add the foreign key from Meal to Recipe.
-- Meal only stores RecipeName, so we also need CookbookName on Meal
-- to keep a correct reference after the PK change.
ALTER TABLE Meal
    ADD COLUMN CookbookName VARCHAR(200) NULL AFTER RecipeName;

-- Populate the new column from the existing Recipe data
UPDATE Meal M
JOIN Recipe R ON M.RecipeName = R.RecipeName
SET M.CookbookName = R.CookbookName;

-- Now make it required and add the composite foreign key
ALTER TABLE Meal
    MODIFY COLUMN CookbookName VARCHAR(200) NOT NULL,
    ADD CONSTRAINT fk_meal_recipe
        FOREIGN KEY (RecipeName, CookbookName)
        REFERENCES Recipe (RecipeName, CookbookName)
        ON UPDATE CASCADE ON DELETE CASCADE;

-- --------------------------------------------------------------------------
-- 2. FamilyMember
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS FamilyMember (
    MemberId                INT NOT NULL AUTO_INCREMENT,
    FirstName               VARCHAR(50) NOT NULL,
    LastName                VARCHAR(50) NOT NULL,
    FavoriteRecipeName      VARCHAR(100) NULL,
    FavoriteCookbookName    VARCHAR(200) NULL,
    PRIMARY KEY (MemberId),
    CONSTRAINT fk_favorite_recipe
        FOREIGN KEY (FavoriteRecipeName, FavoriteCookbookName)
        REFERENCES Recipe (RecipeName, CookbookName)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- --------------------------------------------------------------------------
-- 3. Allergy  (a family member can have many allergens)
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Allergy (
    MemberId    INT NOT NULL,
    Allergen    VARCHAR(100) NOT NULL,
    PRIMARY KEY (MemberId, Allergen),
    CONSTRAINT fk_allergy_member
        FOREIGN KEY (MemberId)
        REFERENCES FamilyMember (MemberId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- --------------------------------------------------------------------------
-- 4. DietaryRestriction
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS DietaryRestriction (
    MemberId        INT NOT NULL,
    Restriction     VARCHAR(100) NOT NULL,
    PRIMARY KEY (MemberId, Restriction),
    CONSTRAINT fk_restriction_member
        FOREIGN KEY (MemberId)
        REFERENCES FamilyMember (MemberId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- --------------------------------------------------------------------------
-- 5. MealPlan  – one planned recipe per meal slot per day (family-wide)
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS MealPlan (
    PlanDate        DATE NOT NULL,
    MealType        ENUM('Breakfast', 'Lunch', 'Dinner') NOT NULL,
    RecipeName      VARCHAR(100) NOT NULL,
    CookbookName    VARCHAR(200) NOT NULL,
    PRIMARY KEY (PlanDate, MealType),
    CONSTRAINT fk_mealplan_recipe
        FOREIGN KEY (RecipeName, CookbookName)
        REFERENCES Recipe (RecipeName, CookbookName)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- --------------------------------------------------------------------------
-- 6. Nutrition  – per-serving nutritional information for a recipe
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Nutrition (
    RecipeName      VARCHAR(100) NOT NULL,
    CookbookName    VARCHAR(200) NOT NULL,
    Calories        DECIMAL(7,2) NULL,
    TotalFat        DECIMAL(6,2) NULL,
    Sodium          DECIMAL(7,2) NULL,
    Carbs           DECIMAL(6,2) NULL,
    Protein         DECIMAL(6,2) NULL,
    PRIMARY KEY (RecipeName, CookbookName),
    CONSTRAINT fk_nutrition_recipe
        FOREIGN KEY (RecipeName, CookbookName)
        REFERENCES Recipe (RecipeName, CookbookName)
        ON UPDATE CASCADE ON DELETE CASCADE
);
