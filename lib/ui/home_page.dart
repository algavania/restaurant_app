import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/ui/detail_page.dart';
import 'package:restaurant_app/widgets/search_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RestaurantItem> _items = [];
  List<RestaurantItem> _allItems = [];
  bool _isLoading = true;
  bool _isPinned = false;
  final ScrollController _sliverScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();

    _sliverScrollController.addListener(() {
      _listenToScrolling();
    });
  }

  void _listenToScrolling() {
    if (!_isPinned &&
        _sliverScrollController.hasClients &&
        _sliverScrollController.offset > kToolbarHeight) {
      setState(() {
        _isPinned = true;
      });
    } else if (_isPinned &&
        _sliverScrollController.hasClients &&
        _sliverScrollController.offset < kToolbarHeight) {
      setState(() {
        _isPinned = false;
      });
    }
  }

  Future<void> _getData() async {
    context.loaderOverlay.show();
    String json = await DefaultAssetBundle.of(context)
        .loadString('assets/restaurant.json');
    Restaurant restaurant = restaurantFromJson(json);
    _items = restaurant.restaurants;
    _allItems = restaurant.restaurants;
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    } else {
      _isLoading = false;
    }
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: !_isPinned,
        child: _buildBody(),
      ),
    );
  }

  CustomScrollView _buildBody() {
    return CustomScrollView(
        controller: _sliverScrollController,
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          _buildTitle(),
          _buildHeader(),
          _isLoading
              ? const SliverToBoxAdapter(child: SizedBox.shrink())
              : _buildList(),
        ],
      );
  }

  SliverList _buildList() {
    return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0, top: index == 0 ? 8 : 0),
                    child: _buildItem(_items[index]),
                  );
                }, childCount: _items.length));
  }

  SliverToBoxAdapter _buildTitle() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cuisination', style: Theme.of(context).textTheme.headline5),
            Text('Best restaurant picked just for you',
                style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildHeader() {
    return SliverAppBar(
      elevation: 0,
      pinned: true,
      expandedHeight: 70,
      toolbarHeight: 70,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: _isPinned ? primaryColor : Colors.white,
          child: SafeArea(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchWidget(
                    hintText: 'What are you looking for?', onChanged: _searchData),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(RestaurantItem item) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.pushNamed(context, DetailPage.routeName, arguments: item);
      },
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
              flex: 2,
              child: Hero(
                tag: 'image${item.id}',
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(item.pictureId, fit: BoxFit.cover)),
              )),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                Text(item.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle2),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 18),
                    const SizedBox(width: 3),
                    Text(item.city, style: Theme.of(context).textTheme.subtitle2),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orangeAccent, size: 18),
                    const SizedBox(width: 3),
                    Text(item.rating.toString(), style: Theme.of(context).textTheme.subtitle2),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  void _searchData(String query) {
    final list = _allItems.where((list) {
      final titleLower = list.name.toLowerCase();
      final cityLower = list.city.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) || cityLower.contains(searchLower);
    }).toList();

    setState(() {
      _items = list;
    });
    _listenToScrolling();
  }
}
