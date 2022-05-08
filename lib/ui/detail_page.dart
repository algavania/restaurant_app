import 'package:flutter/material.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.restaurantItem}) : super(key: key);
  static const routeName = '/detail';
  final RestaurantItem restaurantItem;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ScrollController _sliverScrollController = ScrollController();
  bool _isPinned = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _sliverScrollController,
        slivers: [
          _buildSliverAppBar(),
          _buildContent(),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildContent() {
    return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.restaurantItem.name,
                    style: Theme.of(context).textTheme.headline5),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.red, size: 18),
                    const SizedBox(width: 3),
                    Text(widget.restaurantItem.city,
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Colors.orangeAccent, size: 18),
                    const SizedBox(width: 3),
                    Text(widget.restaurantItem.rating.toString(),
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 10),
                Text(widget.restaurantItem.description),
                const SizedBox(height: 10),
                Text('Foods', style: Theme.of(context).textTheme.headline5),
                ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) => Text(
                      '${i + 1}. ${widget.restaurantItem.menus.foods[i].name}'),
                  shrinkWrap: true,
                  itemCount: widget.restaurantItem.menus.foods.length,
                ),
                const SizedBox(height: 10),
                Text('Drinks', style: Theme.of(context).textTheme.headline5),
                ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) => Text(
                      '${i + 1}. ${widget.restaurantItem.menus.drinks[i].name}'),
                  shrinkWrap: true,
                  itemCount: widget.restaurantItem.menus.drinks.length,
                )
              ],
            ),
          ),
        );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
          pinned: true,
          stretch: true,
          elevation: 0,
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                  color: primaryColor,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context)))),
          title: Text(_isPinned ? widget.restaurantItem.name : ''),
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            background: Hero(
              tag: 'image${widget.restaurantItem.id}',
              child: Image.network(widget.restaurantItem.pictureId,
                  fit: BoxFit.cover),
            ),
          ),
        );
  }
}
