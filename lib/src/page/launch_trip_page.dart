import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:trip/main.dart';
import '../component/mask.dart';
import '../component/navigation_bar.dart';
import '../model/launch_trip_model.dart';
import '../model/trip_model.dart';
import '../service/launch_trrip_service.dart';
import '../service/trrip_service.dart';

class LaunchTripPage extends StatefulWidget {
  Trip trip;

  LaunchTripPage({required this.trip});

  @override
  _LaunchTripState createState() => _LaunchTripState();
}

class _LaunchTripState extends State<LaunchTripPage> {
  List<LaunchTrip> launchTrips = [];

  String local = "";
  int newSequencia = 0;
  String newOrigem = "";
  String newDia = "";
  String newHora = "";
  String newKm = "";

  final TextEditingController _dateController = TextEditingController();
  final MaskTextInputFormatter _dateFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //remove();
    setState(() {
      getLaunchTrips();
    });
  }

  getLaunchTrips() async {
    launchTrips = widget.trip.launchTrips;
  }

  remove() async {
    await LaunchTripService.remove();
  }

  removeItem(int sequencia) async {
    this.launchTrips.removeWhere((item) => item.id == sequencia);
    widget.trip.launchTrips = this.launchTrips;
    await TripService.saveTrip(widget.trip);
  }

  bool isTrip(LaunchTrip elemento, int sequencia) {
    return (elemento.id == sequencia);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getLaunchTrips();
    });

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${widget.trip.empresa}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                      textAlign: TextAlign.center),
                  Text('${widget.trip.origem} -> ${widget.trip.destino}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary)),
                ])),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.trip.launchTrips.length,
                      itemBuilder: (context, index) {
                        return tripItem(context, index);
                      },
                    ),
                  ),
                ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModal(context, null);
            },
            tooltip: 'Iniciar deslocamento!',
            child: const Icon(Icons.add_sharp)),
        bottomNavigationBar:
            MyBottomNavigationBar(context: context, isHome: true));
  }

  Widget tripItem(BuildContext context, index) {
    LaunchTrip trip = widget.trip.launchTrips[index];
    return Card(
        color: Colors.blue[100],
        elevation: 20,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                montaCard(context, widget.trip.launchTrips.last.id, trip)
              ]),
        ));
  }

  Widget montaCard(BuildContext context, int lastId, LaunchTrip trip) {
    local = trip.tipo == 'S' ? 'Saída' : 'Chegada';
    var localPercurso = trip.tipo == 'S' ? 'Origem' : 'Destino';
    String seq = '${trip.id}'.padLeft(2, '0');

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                widget.trip.launchTrips.isNotEmpty && lastId == trip.id
                    ? IconButton(
                        icon: Icon(Icons.delete_outline),
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            removeItem(trip.id);
                          });
                        },
                      )
                    : new Text(''),
                Text('Local de $local',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                widget.trip.launchTrips.isNotEmpty && lastId == trip.id
                    ? IconButton(
                        icon: Icon(Icons.mode_edit_outline),
                        onPressed: () {
                          setState(() {});
                        },
                      )
                    : new Text('')
              ]),
          SizedBox(
            height: 40,
            child: Text('Seq.: ${seq}'),
          ),
          SizedBox(
              height: 30, child: Text('${localPercurso} : ${trip.destino}')),
          SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text(
                          'Dia  :',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${trip.dia}'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Hora :'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${trip.hora}'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Km   :'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${trip.km}')
                      ])),
                ],
              )),
        ]);
  }

  showModal(BuildContext context, LaunchTrip? launchTrip) {
    LaunchTrip? lastLaunchTrip =
        widget.trip.launchTrips.isEmpty ? null : widget.trip.launchTrips.last;

    String localDeslocamento = widget.trip.launchTrips.isEmpty ||
            widget.trip.launchTrips.last.tipo == 'C'
        ? 'Saída'
        : 'Chegada';

    //trips.isNotEmpty && trips.last.tipo == 'C'?newSequencia=trips.last.sequencia=1:newSequencia=trips.last.sequencia;

    if (lastLaunchTrip != null) {
      if (widget.trip.launchTrips.last.tipo == 'C') {
        newSequencia = lastLaunchTrip.id + 1;
      } else {
        newSequencia = lastLaunchTrip.id;
      }
    } else
      newSequencia = 1;

    Mask maskDia = Mask(
        formatter: MaskTextInputFormatter(mask: "##/##/####"),
        hint: '',
        textInputType: TextInputType.datetime);

    _dateController.text = _getFormattedDate();
    maskDia.textController.text = _getFormattedDate();

    Mask maskHora = Mask(
        formatter: MaskTextInputFormatter(mask: "##:##"),
        hint: '',
        textInputType: TextInputType.number);
    maskHora.textController.text = _getFormattedTime();

    Mask maskDestino = Mask(
        formatter: MaskTextInputFormatter(mask: ""),
        hint: '',
        textInputType: TextInputType.number);

    bool isEditKm = true;

    Mask maskKm = Mask(
        formatter: MaskTextInputFormatter(mask: "########"),
        hint: '',
        textInputType: TextInputType.number);
    if (launchTrip != null && lastLaunchTrip!.tipo == 'C') {
      maskKm.textController.text = newKm = lastLaunchTrip.km;
      isEditKm = false;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: Container(
                padding: EdgeInsets.all(20.0),
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                        key: _formkey,
                        child: Scrollbar(
                            child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Card(
                            color: Colors.blue[100],
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ...[
                                    Container(
                                        width: windowWidth - 85,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Local de $localDeslocamento',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor),
                                          maxLines:
                                              1, // Define o número máximo de linhas
                                          overflow: TextOverflow
                                              .ellipsis, // Define como o texto deve lidar com o overflow
                                        )),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      controller: _dateController,
                                      inputFormatters: [_dateFormatter],
                                      decoration: InputDecoration(
                                        labelText: 'Data',
                                      ),
                                      validator: (value) {
                                        if (value == null && value == "") {
                                          return 'Informe a data';
                                        }
                                        if ((lastLaunchTrip != null) &&
                                            !isGoe(_dateController.text) &&
                                            (lastLaunchTrip.tipo == "S")) {
                                          return 'Data deve ser maior ou igual a data de saida';
                                        }
                                        if (isGoe(_dateController.text)) {
                                          return 'Data deve ser maior ou igual a data de atual';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {},
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      maxLength: 5,
                                      inputFormatters: [maskHora.formatter],
                                      controller: maskHora.textController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        hintText: '',
                                        labelText: 'Hora',
                                      ),
                                      validator: (String? value) {
                                        if (value == "") {
                                          return 'Informe a Hora';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newHora = value.toUpperCase();
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      maxLength: 50,
                                      inputFormatters: [maskDestino.formatter],
                                      controller: maskDestino.textController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        hintText: '',
                                        labelText: 'Cidade ou deslocamento',
                                      ),
                                      validator: (String? value) {
                                        if (value == "") {
                                          return 'Informe a cidade ou deslocamento';
                                        }

                                        return null;
                                      },
                                      onChanged: (value) {
                                        newOrigem = value.toUpperCase();
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      enabled: isEditKm,
                                      inputFormatters: [maskKm.formatter],
                                      controller: maskKm.textController,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        hintText: '',
                                        labelText: 'Quilometragem',
                                      ),
                                      validator: (String? value) {
                                        if (value == "") {
                                          return 'Informe a quilometragem';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newKm = value;
                                      },
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: 100,
                                                  child: ElevatedButton(
                                                      child:
                                                          const Text('Gravar'),
                                                      onPressed: () async {
                                                        if (_formkey
                                                            .currentState!
                                                            .validate()) {
                                                          setState(() {
                                                            widget.trip.launchTrips.add(LaunchTrip(
                                                                id: widget
                                                                        .trip
                                                                        .launchTrips
                                                                        .isEmpty
                                                                    ? 1
                                                                    : widget
                                                                            .trip
                                                                            .launchTrips
                                                                            .last
                                                                            .id +
                                                                        1,
                                                                destino: newOrigem
                                                                    .toUpperCase(),
                                                                dia: newDia,
                                                                hora: newHora,
                                                                km: newKm,
                                                                tipo: widget
                                                                            .trip
                                                                            .launchTrips
                                                                            .isEmpty ||
                                                                        widget.trip.launchTrips.last.tipo ==
                                                                            'C'
                                                                    ? 'S'
                                                                    : 'C'));
                                                            TripService
                                                                .saveTrip(widget
                                                                    .trip);
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          return;
                                                        }
                                                      }

                                                      /*_showDialog(switch (200) {
                                                          200 => 'Successfully signed in.',
                                                          401 => 'Unable to sign in.',
                                                          _ => 'Something went wrong. Please try again.'
                                                        });*/
                                                      )),
                                              SizedBox(width: 20),
                                              SizedBox(
                                                  width: 100,
                                                  child: ElevatedButton(
                                                    child:
                                                        const Text('Cancelar'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          this.context);
                                                    },
                                                  ))
                                            ])),
                                  ].expand(
                                    (widget) => [
                                      widget,
                                      const SizedBox(
                                        height: 24,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))))));
      },
    );
  }

  String _getFormattedDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  String _getFormattedTime() {
    var now = DateTime.now();
    String hour = '${now.hour}'.padLeft(2, '0');
    String minute = '${now.minute}'.padLeft(2, '0');
    String formattedTime = '$hour:$minute';
    return formattedTime;
  }

  bool isValidDate(String input) {
    final date = DateTime.parse(input);
    final originalFormatString = toOriginalFormatString(date);
    return input == originalFormatString;
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  bool isGoe(String date) {
    final date1 = DateTime.now();
    final date2 = DateTime.parse(date);
    return date1.isAfter(date2);
  }
}
