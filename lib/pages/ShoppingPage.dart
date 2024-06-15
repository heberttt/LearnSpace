import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnspace/Classes/User.dart';
import 'package:learnspace/Classes/Voucher.dart';
import 'package:learnspace/states.dart';
import 'package:provider/provider.dart';

class ShoppingPageWidget extends StatefulWidget {
  late LearnSpaceUser user;

  ShoppingPageWidget.getUser(this.user, {super.key});

  @override
  State<ShoppingPageWidget> createState() => _ShoppingPageWidgetState();
}

class _ShoppingPageWidgetState extends State<ShoppingPageWidget>
    with TickerProviderStateMixin {
  late ShoppingPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _fetchVoucherCard();
    _fetchPurchasedVoucherCard();
    super.initState();
    _model = createModel(context, () => ShoppingPageModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  List<VoucherCard> _displayedVoucherCards = [];
  List<PurchasedVoucherCard> _displayedPurchasedVoucherCards = [];

  Future<List<String>> _getVoucherCardIDs() async {
    List<String> voucherIDs = [];

    try {
      // Reference to your Firestore collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('vouchers');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through each document and add the document ID to the list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        voucherIDs.add(doc.id);
      }
    } catch (e) {
      print("Error fetching document IDs: $e");
    }

    return voucherIDs;
  }

  Future<void> _fetchVoucherCard() async {
    var fetchedCards = await _getVoucherCards();
    setState(() {
      _displayedVoucherCards = fetchedCards;
    });
  }

  Future<void> _fetchPurchasedVoucherCard() async {
    var fetchedCards = await _getPurchasedVoucherCards();
    setState(() {
      _displayedPurchasedVoucherCards = fetchedCards;
    });
  }


  Future<List<VoucherCard>> _getVoucherCards() async {
    List<String> voucherIDs = await _getVoucherCardIDs();
    List<VoucherCard> gotVoucherCard = [];

    for (String id in voucherIDs) {
      Voucher voucher = Voucher(id);
      await voucher.getOtherDataFromID();
      int voucherLeft = await voucher.getFreeVoucherAmount();
      gotVoucherCard.add(VoucherCard.getVoucher(voucher, voucherLeft));
    }

    return gotVoucherCard;
  }

  Future<List<PurchasedVoucherCard>> _getPurchasedVoucherCards() async {
    List<String> voucherCodes = await _getPurchasedVoucherCardCodes();
    List<PurchasedVoucherCard> gotVoucherCard = [];

    for (String code in voucherCodes) {
      Voucher voucher = Voucher.getEmpty();
      voucher.code = code;
      await voucher.getPurchasedOtherDataFromID(widget.user);
      gotVoucherCard.add(PurchasedVoucherCard.getVoucher(voucher));
    }

    return gotVoucherCard;
  }

  Future<List<String>> _getPurchasedVoucherCardCodes() async {
    List<String> voucherCodes = [];

    try {
      // Reference to your Firestore collection
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.id)
          .collection("vouchers");

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through each document and add the document ID to the list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        voucherCodes.add(doc.id);
      }
    } catch (e) {
      print("Error fetching document IDs: $e");
    }

    return voucherCodes;
  }

  @override
  Widget build(BuildContext context) {
    final myStates = Provider.of<MyStates>(context);
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: FlutterFlowTheme.of(context).primary,
            borderRadius: 20,
            borderWidth: 1,
            buttonSize: 40,
            fillColor: FlutterFlowTheme.of(context).accent1,
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Your points: ${myStates.currentUser.point}',
            textAlign: TextAlign.start,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  letterSpacing: 0,
                  color: Colors.white,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment(0, 0),
                      child: TabBar(
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        labelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Manrope',
                                  letterSpacing: 0,
                                ),
                        unselectedLabelStyle: TextStyle(),
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        padding: EdgeInsets.all(4),
                        tabs: [
                          Tab(
                            text: 'Vouchers',
                          ),
                          Tab(
                            text: 'Purchased',
                          ),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          [() async {}, () async {}][i]();
                        },
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ListView(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: _displayedVoucherCards
                                      .divide(SizedBox(height: 10)),
                                ),
                              ],
                            ),
                          ),
                          RefreshIndicator(
                            onRefresh: () async {
                              _fetchPurchasedVoucherCard();
                            },
                            child: ListView(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              children: [
                                ListView(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: _displayedPurchasedVoucherCards
                                      .divide(SizedBox(height: 10)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PurchasedVoucherCard extends StatefulWidget {
  PurchasedVoucherCard({super.key});

  late Voucher voucher;

  PurchasedVoucherCard.getVoucher(this.voucher, {super.key});

  @override
  State<PurchasedVoucherCard> createState() => _PurchasedVoucherCardState();
}

class _PurchasedVoucherCardState extends State<PurchasedVoucherCard> {
  String _getCode() {
    if (widget.voucher.isRedeemed == true) {
      return "Code Redeemed";
    } else {
      return widget.voucher.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: Container(
                  width: 120,
                  height: 120,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    widget.voucher.voucherProfileLink,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                  child: Text(
                    widget.voucher.title,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Manrope',
                          fontSize: 20,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () {},
                  text: _getCode(),
                  options: FFButtonOptions(
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Manrope',
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VoucherCard extends StatefulWidget {
  VoucherCard({super.key});

  late Voucher voucher;
  late int voucherLeft;
  VoucherCard.getVoucher(this.voucher, this.voucherLeft, {super.key});
  @override
  State<VoucherCard> createState() => _VoucherCardState();
}

class _VoucherCardState extends State<VoucherCard> {
  Future<void> _purchase(BuildContext context) async {
    final myStates = Provider.of<MyStates>(context, listen: false);
    int vleft = await widget.voucher.getFreeVoucherAmount();
    if (vleft > 0) {
      if (myStates.currentUser.point < widget.voucher.price) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Not enough balance'),
                  content: Text(
                    'Your balance is not enough: ${myStates.currentUser.point}',
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      } else {
        widget.voucher.purchaseVoucher(myStates.currentUser);
        myStates.minusPointCurrentUser(widget.voucher.price);
        setState(() {
          widget.voucherLeft--; 
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('No voucher available'),
                content: const Text(
                  'There are no voucher currently available to be purchased',
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                  child: Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      widget.voucher.voucherProfileLink,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                    child: Text(
                      widget.voucher.title,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Manrope',
                            fontSize: 20,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Price: ${widget.voucher.price} points',
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Manrope',
                          letterSpacing: 0,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Available voucher left: ${widget.voucherLeft}',
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Manrope',
                          letterSpacing: 0,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FFButtonWidget(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text('Purchase Voucher'),
                                content: Text(
                                    'Are you sure you would like to puchase "${widget.voucher.title}"?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _purchase(context);

                                      Navigator.pop(context, 'Purchase');
                                    },
                                    child: const Text('Purchase'),
                                  ),
                                ],
                              ),
                          barrierDismissible: true);
                    },
                    text: 'Purchase',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Manrope',
                                color: Colors.white,
                                letterSpacing: 0,
                              ),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingPageModel extends FlutterFlowModel<ShoppingPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
  }
}
