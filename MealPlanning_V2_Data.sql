/* ============================================================================
   MealPlanning Version 2.0 – Additional sample data
   Run AFTER the patch script.
   ============================================================================ */

USE MealPlanning;

-- Family members
INSERT INTO FamilyMember (FirstName, LastName, FavoriteRecipeName, FavoriteCookbookName) VALUES
('Michael', 'Thomas', 'Fajitas', 'Dude Diet'),
('Jennifer', 'Thomas', 'Stir Fry', 'Dude Diet Dinner'),
('Ethan', 'Thomas', 'Chili Mac', 'Delish'),
('Olivia', 'Thomas', 'Philly Style Vanilla Ice Cream', 'Perfect Scoop');

-- Allergies
INSERT INTO Allergy (MemberId, Allergen) VALUES
(1, 'Peanuts'),
(2, 'Shellfish'),
(2, 'Dairy'),
(3, 'Gluten'),
(4, 'Tree Nuts');

-- Dietary restrictions
INSERT INTO DietaryRestriction (MemberId, Restriction) VALUES
(1, 'Low Sodium'),
(2, 'Vegetarian'),
(3, 'No Pork'),
(4, 'Dairy Free');

-- Nutrition (per serving) for existing recipes
INSERT INTO Nutrition (RecipeName, CookbookName, Calories, TotalFat, Sodium, Carbs, Protein) VALUES
('Fajitas', 'Dude Diet', 420.00, 18.50, 780.00, 32.00, 28.00),
('Stir Fry', 'Dude Diet Dinner', 380.00, 14.00, 920.00, 28.00, 26.00),
('Stuffing', 'Domesticate Me', 310.00, 12.00, 640.00, 42.00, 8.00),
('Chicken Stew', 'Dude Diet', 350.00, 11.00, 710.00, 24.00, 32.00),
('Philly Style Vanilla Ice Cream', 'Perfect Scoop', 280.00, 16.00, 90.00, 30.00, 4.00),
('Philly Style Chocolate Ice Cream', 'Perfect Scoop', 310.00, 17.00, 95.00, 34.00, 5.00),
('Beef Stew', 'Delish', 480.00, 22.00, 890.00, 28.00, 36.00),
('Chili Mac', 'Delish', 520.00, 20.00, 980.00, 48.00, 24.00);

-- Meal plans for a sample week (and a bit more)
INSERT INTO MealPlan (PlanDate, MealType, RecipeName, CookbookName) VALUES
-- Week of 2026-11-23
('2026-11-23', 'Breakfast', 'Philly Style Vanilla Ice Cream', 'Perfect Scoop'),
('2026-11-23', 'Lunch', 'Fajitas', 'Dude Diet'),
('2026-11-23', 'Dinner', 'Chicken Stew', 'Dude Diet'),

('2026-11-24', 'Breakfast', 'Philly Style Chocolate Ice Cream', 'Perfect Scoop'),
('2026-11-24', 'Lunch', 'Stir Fry', 'Dude Diet Dinner'),
('2026-11-24', 'Dinner', 'Beef Stew', 'Delish'),

('2026-11-25', 'Breakfast', 'Stuffing', 'Domesticate Me'),
('2026-11-25', 'Lunch', 'Chili Mac', 'Delish'),
('2026-11-25', 'Dinner', 'Fajitas', 'Dude Diet'),

('2026-11-26', 'Breakfast', 'Philly Style Vanilla Ice Cream', 'Perfect Scoop'),
('2026-11-26', 'Lunch', 'Chicken Stew', 'Dude Diet'),
('2026-11-26', 'Dinner', 'Stir Fry', 'Dude Diet Dinner'),

('2026-11-27', 'Breakfast', 'Philly Style Chocolate Ice Cream', 'Perfect Scoop'),
('2026-11-27', 'Lunch', 'Beef Stew', 'Delish'),
('2026-11-27', 'Dinner', 'Chili Mac', 'Delish'),

('2026-11-28', 'Breakfast', 'Stuffing', 'Domesticate Me'),
('2026-11-28', 'Lunch', 'Fajitas', 'Dude Diet'),
('2026-11-28', 'Dinner', 'Chicken Stew', 'Dude Diet'),

('2026-11-29', 'Breakfast', 'Philly Style Vanilla Ice Cream', 'Perfect Scoop'),
('2026-11-29', 'Lunch', 'Stir Fry', 'Dude Diet Dinner'),
('2026-11-29', 'Dinner', 'Beef Stew', 'Delish');
