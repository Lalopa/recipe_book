import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/widgets/favorite_button_widget.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_image_widget.dart';

class MealDetailPage extends StatefulWidget {
  const MealDetailPage({
    required this.meal,
    super.key,
  });

  final Meal meal;

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<FavoriteBloc>().add(const FavoritesLoaded());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  final isFavorite =
                      state.favoriteStatuses[widget.meal.id] ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: FavoriteButtonWidget(
                      mealId: widget.meal.id,
                      isFavorite: isFavorite,
                      size: 28,
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'meal-image-${widget.meal.id}',
                    child: MealImageWidget(
                      imageUrl: widget.meal.thumbnail,
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      bottomBorderRadius: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido de la receta
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Text(
                    widget.meal.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723), // Marrón oscuro
                    ),
                  ),
                ),

                // Tabs
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF68B684),
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: const Color(0xFF3E2723),
                    unselectedLabelColor: const Color(0xFF3E2723),
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: const [
                      Tab(text: 'Ingredients'),
                      Tab(text: 'Directions'),
                    ],
                  ),
                ),

                // Contenido de los tabs
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildIngredientsTab(),
                      _buildDirectionsTab(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          ...widget.meal.ingredients.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 16, top: 2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${entry.key} ${entry.value}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDirectionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Directions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.meal.instructions,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
