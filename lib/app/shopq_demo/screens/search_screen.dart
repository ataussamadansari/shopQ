import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.showBackButton = true,
  });

  final bool showBackButton;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final store = context.read<DemoStore>();
    _controller = TextEditingController(text: store.searchText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openProduct(Product product) {
    Navigator.pushNamed(
      context,
      RouteNames.productDetails,
      arguments: product,
    );
  }

  Future<void> _openFilterSheet(DemoStore store) async {
    Set<String> pending = Set<String>.from(store.activeFilters);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...store.availableFilters.map((filter) {
                      return CheckboxListTile(
                        value: pending.contains(filter),
                        contentPadding: EdgeInsets.zero,
                        title: Text(filter),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (checked) {
                          setModalState(() {
                            if (checked == true) {
                              pending.add(filter);
                            } else {
                              pending.remove(filter);
                            }
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              pending.clear();
                              store.setFilters(pending);
                              Navigator.pop(context);
                            },
                            child: const Text('Clear'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              store.setFilters(pending);
                              Navigator.pop(context);
                            },
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Search',
            showBackButton: widget.showBackButton,
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        onChanged: store.setSearchText,
                        decoration: const InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: Icon(CupertinoIcons.search),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () => _openFilterSheet(store),
                        borderRadius: BorderRadius.circular(14),
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Icon(CupertinoIcons.slider_horizontal_3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (store.activeFilters.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: store.activeFilters
                        .map(
                          (filter) => Chip(
                            label: Text(filter),
                            onDeleted: () {
                              final next = Set<String>.from(store.activeFilters)
                                ..remove(filter);
                              store.setFilters(next);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: store.searchResults.isEmpty
                    ? const _NoSearchResultView()
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: store.searchResults.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final product = store.searchResults[index];
                          return ProductCard(
                            product: product,
                            onTap: () => _openProduct(product),
                            onAdd: () async {
                              final success = await store.addToCart(product);
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? '${product.name} added to cart'
                                        : (store.lastErrorMessage ?? 'Unable to add item'),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NoSearchResultView extends StatelessWidget {
  const _NoSearchResultView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                CupertinoIcons.search_circle_fill,
                size: 50,
                color: Color(0xFF1D4ED8),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try another keyword or adjust your filters.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
