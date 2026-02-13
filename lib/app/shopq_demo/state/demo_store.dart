import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/api/shopq_api_client.dart';
import '../data/demo_repository.dart';
import '../models/address_item.dart';
import '../models/banner_item.dart';
import '../models/cart_item.dart';
import '../models/category_item.dart';
import '../models/order_summary_item.dart';
import '../models/order_status_step.dart';
import '../models/payment_method_item.dart';
import '../models/product.dart';
import '../models/user_profile.dart';

class DemoStore extends ChangeNotifier {
  DemoStore({ShopqApiClient? apiClient}) : _api = apiClient ?? ShopqApiClient() {
    _productById = <String, Product>{
      for (final product in DemoRepository.products) product.id: product,
    };
    _categories = List<CategoryItem>.from(DemoRepository.categories);
    _banners = List<BannerItem>.from(DemoRepository.banners);
    _activeOrderTimeline = List<OrderStatusStep>.from(DemoRepository.orderTimeline);
  }

  final ShopqApiClient _api;

  late final Map<String, Product> _productById;
  late List<CategoryItem> _categories;
  late List<BannerItem> _banners;
  List<CartItem> _cartItems = <CartItem>[];
  List<AddressItem> _addressItems = <AddressItem>[];
  List<PaymentMethodItem> _paymentMethods = <PaymentMethodItem>[];
  List<OrderSummaryItem> _orders = <OrderSummaryItem>[];

  Set<String> _activeFilters = <String>{};
  String _searchText = '';

  int _selectedAddressIndex = 0;
  String _selectedPaymentMethod = 'upi';
  int? _selectedPaymentMethodId;
  String _lastOrderId = 'SQ-NA';
  int? _lastOrderDatabaseId;
  List<OrderStatusStep> _activeOrderTimeline = <OrderStatusStep>[];

  double _subtotal = 0;
  double _shippingFee = 0;
  double _total = 0;

  String? _authToken;
  UserProfile? _currentUser;

  bool _isHomeLoading = true;
  bool _isAuthLoading = false;
  bool _isPlacingOrder = false;
  bool _isTrackingLoading = false;
  bool _isOrdersLoading = false;

  String? _lastErrorMessage;
  String? _lastOtpCode;

  List<Product> get products => List<Product>.unmodifiable(_productById.values);
  List<CategoryItem> get categories => List<CategoryItem>.unmodifiable(_categories);
  List<BannerItem> get banners => List<BannerItem>.unmodifiable(_banners);
  List<String> get addresses => _addressItems.map((address) => address.displayLabel).toList(growable: false);
  List<AddressItem> get addressItems => List<AddressItem>.unmodifiable(_addressItems);
  List<PaymentMethodItem> get paymentMethods => List<PaymentMethodItem>.unmodifiable(_paymentMethods);
  List<OrderSummaryItem> get orders => List<OrderSummaryItem>.unmodifiable(_orders);
  List<String> get availableFilters => DemoRepository.searchFilters;
  List<Product> get featuredProducts => products.where((product) => product.isFeatured).toList();
  List<Product> get flashSaleProducts => products.where((product) => product.isFlashSale).toList();
  bool get isHomeLoading => _isHomeLoading;
  bool get isAuthLoading => _isAuthLoading;
  bool get isPlacingOrder => _isPlacingOrder;
  bool get isTrackingLoading => _isTrackingLoading;
  bool get isOrdersLoading => _isOrdersLoading;
  bool get isAuthenticated => _authToken != null && _authToken!.isNotEmpty;
  String get searchText => _searchText;
  Set<String> get activeFilters => Set<String>.unmodifiable(_activeFilters);
  int get selectedAddressIndex => _selectedAddressIndex;
  String get selectedPaymentMethod => _selectedPaymentMethod;
  int? get selectedPaymentMethodId => _selectedPaymentMethodId;
  String get lastOrderId => _lastOrderId;
  int? get lastOrderDatabaseId => _lastOrderDatabaseId;
  String get apiBaseUrl => _api.baseUrl;
  UserProfile? get currentUser => _currentUser;
  String? get lastErrorMessage => _lastErrorMessage;
  String? get lastOtpCode => _lastOtpCode;
  bool get isCartEmpty => _cartItems.isEmpty;

  Future<void> finishSplashLoad() async {
    _lastErrorMessage = null;

    await Future.wait<void>(<Future<void>>[
      Future<void>.delayed(const Duration(milliseconds: 1300)),
      refreshCatalog(silentError: true),
    ]);

    _isHomeLoading = false;
    notifyListeners();
  }

  Future<void> refreshCatalog({bool silentError = false}) async {
    try {
      final responses = await Future.wait<Map<String, dynamic>>(<Future<Map<String, dynamic>>>[
        _api.getJson('categories'),
        _api.getJson('banners'),
        _api.getJson('products', queryParameters: <String, dynamic>{'per_page': 100}),
      ]);

      final categoriesPayload = _mapList(responses[0]['data']);
      final bannersPayload = _mapList(responses[1]['data']);
      final productsPayload = _mapList(responses[2]['data']);

      _categories = categoriesPayload.map(_categoryFromApi).toList(growable: false);
      _banners = bannersPayload.map(_bannerFromApi).toList(growable: false);

      final parsedProducts = productsPayload.map((json) => _productFromApi(json)).toList(growable: false);
      _productById
        ..clear()
        ..addEntries(parsedProducts.map((product) => MapEntry(product.id, product)));

      _clearError(notify: false);
    } catch (error) {
      if (!silentError) {
        _setError(_errorMessage(error), notify: false);
      }
    }

    notifyListeners();
  }

  Future<String?> requestOtp({
    required String phone,
    String purpose = 'login',
  }) async {
    if (phone.trim().isEmpty) {
      _setError('Enter phone number to request OTP.');
      return null;
    }

    _isAuthLoading = true;
    _clearError(notify: false);
    notifyListeners();

    try {
      final response = await _api.postJson(
        'auth/request-otp',
        data: <String, dynamic>{
          'phone': phone.trim(),
          'purpose': purpose,
        },
      );

      final payload = response['data'] is Map<String, dynamic> ? response['data'] as Map<String, dynamic> : response;
      _lastOtpCode = payload['otp']?.toString() ?? response['otp']?.toString();
      return _lastOtpCode;
    } catch (error) {
      _setError(_errorMessage(error), notify: false);
      return null;
    } finally {
      _isAuthLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp({
    required String phone,
    required String otpCode,
    String purpose = 'login',
    String? name,
  }) async {
    if (phone.trim().isEmpty) {
      _setError('Please enter phone number.');
      return false;
    }

    if (otpCode.trim().isEmpty) {
      _setError('Please enter OTP code.');
      return false;
    }

    _isAuthLoading = true;
    _clearError(notify: false);
    notifyListeners();

    try {
      final response = await _api.postJson(
        'auth/verify-otp',
        data: <String, dynamic>{
          'phone': phone.trim(),
          'otp_code': otpCode.trim(),
          'purpose': purpose,
          if ((name ?? '').trim().isNotEmpty) 'name': name!.trim(),
        },
      );

      await _applyAuthResponse(response);
      return true;
    } catch (error) {
      _setError(_errorMessage(error), notify: false);
      return false;
    } finally {
      _isAuthLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      if (isAuthenticated) {
        await _api.postJson('auth/logout', authRequired: true);
      }
    } catch (_) {
      // Keep local logout resilient even if backend fails.
    }

    _authToken = null;
    _api.setToken(null);
    _currentUser = null;
    _addressItems = <AddressItem>[];
    _paymentMethods = <PaymentMethodItem>[];
    _orders = <OrderSummaryItem>[];
    _cartItems = <CartItem>[];
    _subtotal = 0;
    _shippingFee = 0;
    _total = 0;
    _selectedAddressIndex = 0;
    _selectedPaymentMethod = 'upi';
    _selectedPaymentMethodId = null;
    _lastOrderDatabaseId = null;
    _lastOrderId = 'SQ-NA';
    _activeOrderTimeline = List<OrderStatusStep>.from(DemoRepository.orderTimeline);
    _isOrdersLoading = false;
    _isTrackingLoading = false;
    _isPlacingOrder = false;
    _clearError(notify: false);
    notifyListeners();
  }

  Future<void> refreshAddresses() async {
    if (!isAuthenticated) {
      _addressItems = <AddressItem>[];
      _selectedAddressIndex = 0;
      notifyListeners();
      return;
    }

    try {
      final response = await _api.getJson('addresses', authRequired: true);
      final data = _mapList(response['data']);
      _addressItems = data.map(_addressFromApi).toList(growable: false);

      if (_addressItems.isEmpty) {
        _selectedAddressIndex = 0;
      } else {
        final defaultIndex = _addressItems.indexWhere((address) => address.isDefault);
        _selectedAddressIndex = defaultIndex >= 0 ? defaultIndex : min(_selectedAddressIndex, _addressItems.length - 1);
      }
    } catch (error) {
      _setError(_errorMessage(error), notify: false);
    }

    notifyListeners();
  }

  Future<bool> createAddress({
    required String label,
    required String recipientName,
    required String phone,
    required String line1,
    String? line2,
    required String city,
    required String state,
    required String postalCode,
    String country = 'India',
    bool isDefault = false,
  }) async {
    if (!isAuthenticated) {
      _setError('Please login to manage addresses.');
      return false;
    }

    try {
      await _api.postJson(
        'addresses',
        authRequired: true,
        data: <String, dynamic>{
          'label': label.trim(),
          'recipient_name': recipientName.trim(),
          'phone': phone.trim(),
          'line1': line1.trim(),
          'line2': (line2 ?? '').trim().isEmpty ? null : line2!.trim(),
          'city': city.trim(),
          'state': state.trim(),
          'postal_code': postalCode.trim(),
          'country': country.trim(),
          'is_default': isDefault,
        },
      );
      await refreshAddresses();
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<bool> updateAddress({
    required int id,
    required String label,
    required String recipientName,
    required String phone,
    required String line1,
    String? line2,
    required String city,
    required String state,
    required String postalCode,
    String country = 'India',
    bool isDefault = false,
  }) async {
    if (!isAuthenticated) {
      _setError('Please login to manage addresses.');
      return false;
    }

    try {
      await _api.patchJson(
        'addresses/$id',
        authRequired: true,
        data: <String, dynamic>{
          'label': label.trim(),
          'recipient_name': recipientName.trim(),
          'phone': phone.trim(),
          'line1': line1.trim(),
          'line2': (line2 ?? '').trim().isEmpty ? null : line2!.trim(),
          'city': city.trim(),
          'state': state.trim(),
          'postal_code': postalCode.trim(),
          'country': country.trim(),
          'is_default': isDefault,
        },
      );
      await refreshAddresses();
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<bool> deleteAddress(int id) async {
    if (!isAuthenticated) {
      _setError('Please login to manage addresses.');
      return false;
    }

    try {
      await _api.deleteJson(
        'addresses/$id',
        authRequired: true,
      );
      await refreshAddresses();
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<bool> setDefaultAddress(int id) async {
    if (!isAuthenticated) {
      _setError('Please login to manage addresses.');
      return false;
    }

    try {
      await _api.patchJson(
        'addresses/$id/set-default',
        authRequired: true,
      );
      await refreshAddresses();
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<void> refreshPaymentMethods() async {
    if (!isAuthenticated) {
      _paymentMethods = <PaymentMethodItem>[];
      _selectedPaymentMethod = 'upi';
      _selectedPaymentMethodId = null;
      notifyListeners();
      return;
    }

    try {
      final response = await _api.getJson('payment-methods', authRequired: true);
      final data = _mapList(response['data']);
      _paymentMethods = data.map(_paymentMethodFromApi).toList(growable: false);
      _syncSelectedPaymentMethod();
      _clearError(notify: false);
    } catch (error) {
      _setError(_errorMessage(error), notify: false);
    }

    notifyListeners();
  }

  Future<bool> createPaymentMethod({
    required String type,
    required String label,
    String? holderName,
    String? upiId,
    String? cardLastFour,
    String? cardNetwork,
    int? expiryMonth,
    int? expiryYear,
    bool isDefault = false,
  }) async {
    if (!isAuthenticated) {
      _setError('Please login to manage payment methods.');
      return false;
    }

    try {
      await _api.postJson(
        'payment-methods',
        authRequired: true,
        data: <String, dynamic>{
          'type': type,
          'label': label.trim(),
          'holder_name': (holderName ?? '').trim().isEmpty ? null : holderName!.trim(),
          'upi_id': (upiId ?? '').trim().isEmpty ? null : upiId!.trim(),
          'card_last_four': (cardLastFour ?? '').trim().isEmpty ? null : cardLastFour!.trim(),
          'card_network': (cardNetwork ?? '').trim().isEmpty ? null : cardNetwork!.trim(),
          'expiry_month': expiryMonth,
          'expiry_year': expiryYear,
          'is_default': isDefault,
          'is_active': true,
        },
      );
      await refreshPaymentMethods();
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<bool> updatePaymentMethod({
    required int id,
    required String type,
    required String label,
    String? holderName,
    String? upiId,
    String? cardLastFour,
    String? cardNetwork,
    int? expiryMonth,
    int? expiryYear,
    bool isDefault = false,
  }) async {
    if (!isAuthenticated) {
      _setError('Please login to manage payment methods.');
      return false;
    }

    try {
      await _api.patchJson(
        'payment-methods/$id',
        authRequired: true,
        data: <String, dynamic>{
          'type': type,
          'label': label.trim(),
          'holder_name': (holderName ?? '').trim().isEmpty ? null : holderName!.trim(),
          'upi_id': (upiId ?? '').trim().isEmpty ? null : upiId!.trim(),
          'card_last_four': (cardLastFour ?? '').trim().isEmpty ? null : cardLastFour!.trim(),
          'card_network': (cardNetwork ?? '').trim().isEmpty ? null : cardNetwork!.trim(),
          'expiry_month': expiryMonth,
          'expiry_year': expiryYear,
          'is_default': isDefault,
          'is_active': true,
        },
      );
      await refreshPaymentMethods();
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<bool> deletePaymentMethod(int id) async {
    if (!isAuthenticated) {
      _setError('Please login to manage payment methods.');
      return false;
    }

    try {
      await _api.deleteJson(
        'payment-methods/$id',
        authRequired: true,
      );
      await refreshPaymentMethods();
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<bool> setDefaultPaymentMethod(int id) async {
    if (!isAuthenticated) {
      _setError('Please login to manage payment methods.');
      return false;
    }

    try {
      await _api.patchJson(
        'payment-methods/$id/set-default',
        authRequired: true,
      );
      await refreshPaymentMethods();
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<void> refreshOrders({bool silentError = false}) async {
    if (!isAuthenticated) {
      _orders = <OrderSummaryItem>[];
      _isOrdersLoading = false;
      notifyListeners();
      return;
    }

    _isOrdersLoading = true;
    notifyListeners();

    try {
      final response = await _api.getJson(
        'orders',
        authRequired: true,
        queryParameters: <String, dynamic>{'per_page': 50},
      );
      final orderList = _mapList(response['data']);
      _orders = orderList.map(_orderSummaryFromApi).toList(growable: false);

      if (_orders.isNotEmpty && _lastOrderDatabaseId == null) {
        _lastOrderDatabaseId = _orders.first.id;
        _lastOrderId = _orders.first.orderNumber;
      }

      _clearError(notify: false);
    } catch (error) {
      if (!silentError) {
        _setError(_errorMessage(error), notify: false);
      }
    } finally {
      _isOrdersLoading = false;
      notifyListeners();
    }
  }

  List<Product> get searchResults {
    final query = _searchText.trim().toLowerCase();
    Iterable<Product> results = products.where((product) {
      final target = '${product.name} ${product.description}'.toLowerCase();
      return query.isEmpty || target.contains(query);
    });

    for (final filter in _activeFilters) {
      switch (filter) {
        case 'Under \$50':
          results = results.where((product) => product.price < 50);
          break;
        case '4.0+ Rating':
          results = results.where((product) => product.rating >= 4.0);
          break;
        case 'Flash Sale':
          results = results.where((product) => product.isFlashSale);
          break;
        case 'In Stock':
          results = results.where((product) => product.inStock);
          break;
      }
    }

    return results.toList(growable: false);
  }

  void setSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  void setFilters(Set<String> filters) {
    _activeFilters = Set<String>.from(filters);
    notifyListeners();
  }

  void clearSearchAndFilters() {
    _searchText = '';
    _activeFilters.clear();
    notifyListeners();
  }

  List<CartItem> get cartItems => List<CartItem>.unmodifiable(_cartItems);

  int get cartCount {
    return _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  int quantityForProduct(String productId) {
    return _findCartItemByProductId(productId)?.quantity ?? 0;
  }

  Future<void> fetchCart({bool silentError = false}) async {
    if (!isAuthenticated) {
      _cartItems = <CartItem>[];
      _subtotal = 0;
      _shippingFee = 0;
      _total = 0;
      notifyListeners();
      return;
    }

    try {
      final response = await _api.getJson('cart', authRequired: true);
      final data = response['data'];
      final summary = response['summary'];

      final itemsPayload = _mapList(data is Map<String, dynamic> ? data['items'] : null);
      _cartItems = itemsPayload.map(_cartItemFromApi).toList(growable: false);

      _subtotal = _toDouble(summary is Map<String, dynamic> ? summary['subtotal'] : null) ?? _calculateSubtotal();
      _shippingFee = _toDouble(summary is Map<String, dynamic> ? summary['shipping_fee'] : null) ?? (_cartItems.isEmpty ? 0 : 4.99);
      _total = _toDouble(summary is Map<String, dynamic> ? summary['total'] : null) ?? (_subtotal + _shippingFee);

      _clearError(notify: false);
    } catch (error) {
      if (!silentError) {
        _setError(_errorMessage(error), notify: false);
      }
    }

    notifyListeners();
  }

  Future<bool> addToCart(Product product, {int quantity = 1}) async {
    if (!isAuthenticated) {
      _setError('Please login to add products to cart.');
      return false;
    }

    final productId = int.tryParse(product.id);
    if (productId == null) {
      _setError('Unable to add this product from offline data.');
      return false;
    }

    try {
      await _api.postJson(
        'cart/items',
        authRequired: true,
        data: <String, dynamic>{
          'product_id': productId,
          'quantity': max(1, quantity),
        },
      );
      await fetchCart(silentError: true);
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<bool> updateQuantity(String productId, int quantity) async {
    final item = _findCartItemByProductId(productId);

    if (item == null) {
      return false;
    }

    if (quantity <= 0) {
      return removeFromCart(productId);
    }

    try {
      await _api.patchJson(
        'cart/items/${item.id}',
        authRequired: true,
        data: <String, dynamic>{
          'quantity': quantity,
        },
      );
      await fetchCart(silentError: true);
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  Future<bool> removeFromCart(String productId) async {
    final item = _findCartItemByProductId(productId);

    if (item == null) {
      return false;
    }

    try {
      await _api.deleteJson(
        'cart/items/${item.id}',
        authRequired: true,
      );
      await fetchCart(silentError: true);
      return true;
    } catch (error) {
      _setError(_errorMessage(error));
      return false;
    }
  }

  double get subtotal => _subtotal;
  double get shippingFee => _shippingFee;
  double get total => _total;

  String money(double value) => '\$${value.toStringAsFixed(2)}';

  void setSelectedAddress(int index) {
    if (_addressItems.isEmpty) {
      _selectedAddressIndex = 0;
    } else {
      _selectedAddressIndex = index.clamp(0, _addressItems.length - 1);
    }
    notifyListeners();
  }

  void setSelectedPaymentMethod(String method, {int? paymentMethodId}) {
    _selectedPaymentMethod = method;
    _selectedPaymentMethodId = paymentMethodId;

    if (_selectedPaymentMethodId == null && _paymentMethods.isNotEmpty) {
      for (final item in _paymentMethods) {
        if (item.type == method) {
          _selectedPaymentMethodId = item.id;
          break;
        }
      }
    }

    notifyListeners();
  }

  Future<bool> placeOrder() async {
    if (!isAuthenticated) {
      _setError('Please login to place order.');
      return false;
    }

    if (_cartItems.isEmpty) {
      _setError('Cart is empty. Add products before checkout.');
      return false;
    }

    if (_addressItems.isEmpty) {
      _setError('No address available. Add an address from backend first.');
      return false;
    }

    _isPlacingOrder = true;
    _clearError(notify: false);
    notifyListeners();

    try {
      final addressId = _addressItems[_selectedAddressIndex].id;
      final response = await _api.postJson(
        'checkout',
        authRequired: true,
        data: <String, dynamic>{
          'address_id': addressId,
          'payment_method': _selectedPaymentMethod,
        },
      );

      final data = response['data'] is Map<String, dynamic> ? response['data'] as Map<String, dynamic> : <String, dynamic>{};
      _lastOrderDatabaseId = _toInt(data['id']);
      _lastOrderId = data['order_number']?.toString() ?? _lastOrderId;
      _activeOrderTimeline = _trackingListFromApi(data['tracking']);

      await fetchCart(silentError: true);
      await refreshOrders(silentError: true);
      return true;
    } catch (error) {
      _setError(_errorMessage(error), notify: false);
      return false;
    } finally {
      _isPlacingOrder = false;
      notifyListeners();
    }
  }

  Future<void> refreshOrderTracking({int? orderId}) async {
    if (!isAuthenticated) {
      return;
    }

    if (orderId != null) {
      _lastOrderDatabaseId = orderId;
    }

    _isTrackingLoading = true;
    notifyListeners();

    try {
      if (_lastOrderDatabaseId != null) {
        final orderResponse = await _api.getJson('orders/${_lastOrderDatabaseId!}', authRequired: true);
        final orderData = orderResponse['data'] is Map<String, dynamic>
            ? orderResponse['data'] as Map<String, dynamic>
            : <String, dynamic>{};

        _lastOrderId = orderData['order_number']?.toString() ?? _lastOrderId;
        _activeOrderTimeline = _trackingListFromApi(orderData['tracking']);
        _upsertOrder(orderData);
      } else {
        final ordersResponse = await _api.getJson(
          'orders',
          authRequired: true,
          queryParameters: <String, dynamic>{'per_page': 1},
        );

        final orderList = _mapList(ordersResponse['data']);
        if (orderList.isNotEmpty) {
          final firstOrder = orderList.first;
          _lastOrderDatabaseId = _toInt(firstOrder['id']);
          _lastOrderId = firstOrder['order_number']?.toString() ?? _lastOrderId;
          _activeOrderTimeline = _trackingListFromApi(firstOrder['tracking']);
          _upsertOrder(firstOrder);
        } else {
          _lastOrderDatabaseId = null;
          _lastOrderId = 'SQ-NA';
          _activeOrderTimeline = List<OrderStatusStep>.from(DemoRepository.orderTimeline);
        }
      }
    } catch (error) {
      _setError(_errorMessage(error), notify: false);
    } finally {
      _isTrackingLoading = false;
      notifyListeners();
    }
  }

  List<OrderStatusStep> get orderTimeline {
    if (_activeOrderTimeline.isNotEmpty) {
      return List<OrderStatusStep>.unmodifiable(_activeOrderTimeline);
    }
    return List<OrderStatusStep>.unmodifiable(DemoRepository.orderTimeline);
  }

  List<String> reviewsForProduct(String productId) {
    return DemoRepository.reviews[productId] ??
        <String>[
          'Looks great and matches description.',
          'Smooth delivery experience and quality packaging.',
        ];
  }

  void clearError() {
    _clearError();
  }

  Future<void> _applyAuthResponse(Map<String, dynamic> response) async {
    final payload = response['data'] is Map<String, dynamic> ? response['data'] as Map<String, dynamic> : response;

    final token = payload['token']?.toString() ?? response['token']?.toString();
    if (token == null || token.isEmpty) {
      throw ShopqApiException('Authentication succeeded but token was missing.');
    }

    _authToken = token;
    _api.setToken(token);

    final userData = payload['user'] is Map<String, dynamic>
        ? payload['user'] as Map<String, dynamic>
        : (response['user'] is Map<String, dynamic> ? response['user'] as Map<String, dynamic> : <String, dynamic>{});
    _currentUser = _userFromApi(userData);

    await Future.wait<void>(<Future<void>>[
      refreshAddresses(),
      refreshPaymentMethods(),
      fetchCart(silentError: true),
      refreshCatalog(silentError: true),
      refreshOrders(silentError: true),
    ]);
  }

  List<OrderStatusStep> _trackingListFromApi(dynamic raw) {
    final payload = _mapList(raw);
    if (payload.isEmpty) {
      return List<OrderStatusStep>.from(DemoRepository.orderTimeline);
    }

    return payload.map((statusJson) {
      final statusCode = statusJson['status']?.toString() ?? 'pending';
      final title = _titleFromStatus(statusCode);
      return OrderStatusStep(
        title: title,
        description: statusJson['description']?.toString() ?? '$title update pending.',
        time: _toDateTime(statusJson['tracked_at']),
        completed: _toBool(statusJson['is_completed']) ?? false,
      );
    }).toList(growable: false);
  }

  CartItem _cartItemFromApi(Map<String, dynamic> json) {
    final productJson = json['product'] is Map<String, dynamic> ? json['product'] as Map<String, dynamic> : <String, dynamic>{};

    final productId = (json['product_id'] ?? productJson['id'] ?? '').toString();
    final fallbackProduct = _productById[productId];

    final product = Product(
      id: productId,
      name: productJson['name']?.toString() ?? fallbackProduct?.name ?? 'Product',
      description: fallbackProduct?.description ?? 'Description not available.',
      imageAssets: _stringList(productJson['images']).isNotEmpty
          ? _stringList(productJson['images'])
          : (fallbackProduct?.imageAssets ?? <String>['assets/images/img.png']),
      price: _toDouble(productJson['price']) ?? _toDouble(json['unit_price']) ?? fallbackProduct?.price ?? 0,
      originalPrice: fallbackProduct?.originalPrice ?? (_toDouble(productJson['price']) ?? _toDouble(json['unit_price']) ?? 0),
      rating: fallbackProduct?.rating ?? 0,
      reviewCount: fallbackProduct?.reviewCount ?? 0,
      categoryId: fallbackProduct?.categoryId ?? '',
      isFeatured: fallbackProduct?.isFeatured ?? false,
      isFlashSale: fallbackProduct?.isFlashSale ?? false,
      inStock: (_toInt(productJson['stock']) ?? 1) > 0,
    );

    _productById[product.id] = product;

    return CartItem(
      id: _toInt(json['id']) ?? 0,
      product: product,
      quantity: _toInt(json['quantity']) ?? 1,
      unitPrice: _toDouble(json['unit_price']) ?? product.price,
    );
  }

  CategoryItem _categoryFromApi(Map<String, dynamic> json) {
    return CategoryItem(
      id: (json['id'] ?? '').toString(),
      title: json['name']?.toString() ?? 'Category',
      icon: _iconFromKey(json['icon']?.toString()),
    );
  }

  BannerItem _bannerFromApi(Map<String, dynamic> json) {
    return BannerItem(
      id: (json['id'] ?? '').toString(),
      title: json['title']?.toString() ?? 'ShopQ Banner',
      subtitle: json['subtitle']?.toString() ?? '',
      imageAsset: json['image_url']?.toString() ?? 'assets/images/img.png',
      accentColor: _colorFromHex(json['accent_color']?.toString()) ?? const Color(0xFF15803D),
    );
  }

  Product _productFromApi(Map<String, dynamic> json) {
    final price = _toDouble(json['price']) ?? 0;
    final originalPrice = _toDouble(json['original_price']) ?? price;
    final images = _stringList(json['images']);

    return Product(
      id: (json['id'] ?? '').toString(),
      name: json['name']?.toString() ?? 'Product',
      description: json['description']?.toString() ?? 'No description available.',
      imageAssets: images.isEmpty ? <String>['assets/images/img.png'] : images,
      price: price,
      originalPrice: originalPrice,
      rating: _toDouble(json['rating']) ?? 0,
      reviewCount: _toInt(json['review_count']) ?? 0,
      categoryId: (json['category_id'] ?? '').toString(),
      isFeatured: _toBool(json['featured']) ?? false,
      isFlashSale: _toBool(json['flash_sale']) ?? false,
      inStock: _toBool(json['in_stock']) ?? ((_toInt(json['stock']) ?? 0) > 0),
    );
  }

  AddressItem _addressFromApi(Map<String, dynamic> json) {
    return AddressItem(
      id: _toInt(json['id']) ?? 0,
      label: json['label']?.toString() ?? 'Address',
      recipientName: json['recipient_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      line1: json['line1']?.toString() ?? '',
      line2: json['line2']?.toString(),
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      postalCode: json['postal_code']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      isDefault: _toBool(json['is_default']) ?? false,
    );
  }

  PaymentMethodItem _paymentMethodFromApi(Map<String, dynamic> json) {
    return PaymentMethodItem(
      id: _toInt(json['id']) ?? 0,
      type: json['type']?.toString() ?? 'upi',
      label: json['label']?.toString() ?? 'Payment Method',
      holderName: json['holder_name']?.toString(),
      upiId: json['upi_id']?.toString(),
      cardLastFour: json['card_last_four']?.toString(),
      cardNetwork: json['card_network']?.toString(),
      expiryMonth: _toInt(json['expiry_month']),
      expiryYear: _toInt(json['expiry_year']),
      isDefault: _toBool(json['is_default']) ?? false,
      isActive: _toBool(json['is_active']) ?? true,
    );
  }

  OrderSummaryItem _orderSummaryFromApi(Map<String, dynamic> json) {
    final tracking = _trackingListFromApi(json['tracking']);
    return OrderSummaryItem(
      id: _toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? 'SQ-NA',
      status: json['status']?.toString() ?? 'confirmed',
      paymentMethod: json['payment_method']?.toString() ?? 'upi',
      paymentStatus: json['payment_status']?.toString() ?? 'pending',
      subtotal: _toDouble(json['subtotal']) ?? 0,
      shippingFee: _toDouble(json['shipping_fee']) ?? 0,
      total: _toDouble(json['total']) ?? 0,
      itemsCount: _toInt(json['items_count']) ?? 0,
      placedAt: _toDateTime(json['placed_at']),
      tracking: tracking,
    );
  }

  UserProfile _userFromApi(Map<String, dynamic> json) {
    return UserProfile(
      id: _toInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? 'ShopQ User',
      phone: json['phone']?.toString(),
    );
  }

  IconData _iconFromKey(String? key) {
    switch (key) {
      case 'cart':
        return CupertinoIcons.cart;
      case 'bag':
        return CupertinoIcons.bag;
      case 'device_phone_portrait':
        return CupertinoIcons.device_phone_portrait;
      case 'heart_circle':
        return CupertinoIcons.heart_circle;
      case 'sportscourt':
        return CupertinoIcons.sportscourt;
      case 'house':
        return CupertinoIcons.house;
      default:
        return CupertinoIcons.square_grid_2x2;
    }
  }

  Color? _colorFromHex(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    var hex = raw.trim().replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    final value = int.tryParse(hex, radix: 16);
    if (value == null) {
      return null;
    }
    return Color(value);
  }

  String _titleFromStatus(String statusCode) {
    switch (statusCode.toLowerCase()) {
      case 'confirmed':
        return 'Order Confirmed';
      case 'packed':
        return 'Packed';
      case 'shipped':
        return 'Shipped';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'canceled':
        return 'Canceled';
      default:
        return 'Status Updated';
    }
  }

  String _errorMessage(Object error) {
    if (error is ShopqApiException) {
      return error.message;
    }
    return 'Something went wrong. Please try again.';
  }

  List<Map<String, dynamic>> _mapList(dynamic raw) {
    if (raw is! List) {
      return <Map<String, dynamic>>[];
    }
    return raw.whereType<Map<String, dynamic>>().toList(growable: false);
  }

  List<String> _stringList(dynamic raw) {
    if (raw is! List) {
      return <String>[];
    }
    return raw.map((item) => item.toString()).toList(growable: false);
  }

  double _calculateSubtotal() {
    return _cartItems.fold<double>(0, (sum, item) => sum + item.lineTotal);
  }

  int? _toInt(dynamic raw) {
    if (raw is int) {
      return raw;
    }
    if (raw is double) {
      return raw.round();
    }
    if (raw is String) {
      return int.tryParse(raw);
    }
    return null;
  }

  double? _toDouble(dynamic raw) {
    if (raw is double) {
      return raw;
    }
    if (raw is int) {
      return raw.toDouble();
    }
    if (raw is String) {
      return double.tryParse(raw);
    }
    return null;
  }

  bool? _toBool(dynamic raw) {
    if (raw is bool) {
      return raw;
    }
    if (raw is int) {
      return raw != 0;
    }
    if (raw is String) {
      final value = raw.toLowerCase();
      if (value == 'true' || value == '1') {
        return true;
      }
      if (value == 'false' || value == '0') {
        return false;
      }
    }
    return null;
  }

  DateTime? _toDateTime(dynamic raw) {
    if (raw is DateTime) {
      return raw;
    }
    if (raw is String && raw.trim().isNotEmpty) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  CartItem? _findCartItemByProductId(String productId) {
    for (final item in _cartItems) {
      if (item.product.id == productId) {
        return item;
      }
    }
    return null;
  }

  void _upsertOrder(Map<String, dynamic> json) {
    final parsed = _orderSummaryFromApi(json);
    final index = _orders.indexWhere((order) => order.id == parsed.id);

    if (index >= 0) {
      _orders[index] = parsed;
      return;
    }

    _orders = <OrderSummaryItem>[parsed, ..._orders];
  }

  void _syncSelectedPaymentMethod() {
    if (_paymentMethods.isEmpty) {
      _selectedPaymentMethod = 'upi';
      _selectedPaymentMethodId = null;
      return;
    }

    PaymentMethodItem? selected;

    if (_selectedPaymentMethodId != null) {
      for (final item in _paymentMethods) {
        if (item.id == _selectedPaymentMethodId) {
          selected = item;
          break;
        }
      }
    }

    selected ??= _paymentMethods.firstWhere(
      (item) => item.isDefault,
      orElse: () => _paymentMethods.first,
    );

    _selectedPaymentMethod = selected.type;
    _selectedPaymentMethodId = selected.id;
  }

  void _setError(String message, {bool notify = true}) {
    _lastErrorMessage = message;
    if (notify) {
      notifyListeners();
    }
  }

  void _clearError({bool notify = true}) {
    _lastErrorMessage = null;
    if (notify) {
      notifyListeners();
    }
  }
}
