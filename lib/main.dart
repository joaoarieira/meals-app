import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/models/settings.dart';
import 'package:meals_app/screens/categories_meals_screen.dart';
import 'package:meals_app/screens/meal_detail_screen.dart';
import 'package:meals_app/screens/settings_screen.dart';
import 'package:meals_app/screens/tabs_screen.dart';
import 'package:meals_app/utils/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var settings = Settings();
  var _meals = DUMMY_MEALS;
  final _favoriteMeals = <Meal>[];

  void _filterMeals(Settings settings) {
    setState(() {
      this.settings = settings;
      _meals = _meals.where((meal) {
        final showGlutenFree = !settings.isGlutenFree || meal.isGlutenFree;
        final showLactoseFree = !settings.isLactoseFree || meal.isLactoseFree;
        final showVegan = !settings.isVegan || meal.isVegan;
        final showVegetarian = !settings.isVegetarian || meal.isVegetarian;
        return showGlutenFree && showLactoseFree && showVegetarian && showVegan;
      }).toList();
    });
  }

  void _toggleFavorite(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal)
          ? _favoriteMeals.remove(meal)
          : _favoriteMeals.add(meal);
    });
  }

  bool _isMealFavorited(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(
      fontFamily: 'Raleway',
      canvasColor: const Color.fromRGBO(255, 254, 229, 1),
    );

    return MaterialApp(
      title: 'DeliMeals',
      theme: themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(
          primary: Colors.pink,
          secondary: Colors.amber,
        ),
        textTheme: themeData.textTheme.copyWith(
          headline6: const TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            color: Colors.black87,
          ),
        ),
        floatingActionButtonTheme: themeData.floatingActionButtonTheme.copyWith(
          foregroundColor: Colors.black54,
        ),
      ),
      routes: {
        AppRoutes.HOME: (context) => TabsScreen(
              favoriteMeals: _favoriteMeals,
            ),
        AppRoutes.CATEGORIES_MEALS: (context) => CategoriesMealsScreen(
              meals: _meals,
            ),
        AppRoutes.MEAL_DETAILS: (context) => MealDetailScreen(
              onToggleFavorite: _toggleFavorite,
              isMealFavorited: _isMealFavorited,
            ),
        AppRoutes.SETTINGS: (context) => SettingsScreen(
              onSettingsChanged: _filterMeals,
              settings: settings,
            ),
      },
    );
  }
}
