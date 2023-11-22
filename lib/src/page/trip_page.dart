import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../model/launch_trip_model.dart';
import '../page/launch_trip_page.dart';
import '../component/mask.dart';
import '../model/trip_model.dart';
import '../service/trrip_service.dart';

class TripPage extends StatefulWidget {
  const TripPage({
    super.key,
  });

  @override
  State<TripPage> createState() => _SignUpState();
}

class _SignUpState extends State<TripPage> {
  List<Trip> trips = [];
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Trip? trip;
  String newMatricula = "";
  String newFrota = "";

  @override
  void initState() {
    super.initState();
    //remove();
    TripService.get().then((value) {
      setState(() {
        trips = value;
      });
    });
  }

  remove() async {
    await TripService.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.manage_accounts_outlined),
            onPressed: () {
              Navigator.pushNamed(this.context, '/user');
            },
          ),
          title: Text('VIAGEM',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                //Navigator.pushNamed(this.context, '/user');
              },
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: trips.length,
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
            child: const Icon(Icons.add_sharp)));
  }

  Widget tripItem(BuildContext context, index) {
    Trip trip = trips[index];
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
              children: <Widget>[montaCard(context, trip)]),
        ));
  }

  Widget montaCard(BuildContext context, Trip trip) {
    String idStr = trip.id.toString().padLeft(2, '0');
    return GestureDetector(
        onTap: () {
          showModal(context, trip);
        },
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              SizedBox(
                  height: 30,
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              removeItem(trip.id);
                            });
                          },
                        ),
                        Text('${trip.empresa}',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: () {
                            /*Navigator.pushReplacement<void, void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    LaunchTripPage(trip: trip),
                              ),
                            );*/
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    LaunchTripPage(trip: trip),
                              ),
                            );
                          },
                        )
                      ]))),
              SizedBox(height: 20),
              SizedBox(
                  height: 40,
                  child: Text(
                      'Id : ${idStr}   Frota : ${trip.frota}    Mátricula : ${trip.matricula} ')),
              SizedBox(
                  height: 30,
                  child: Text('De ${trip.origem}  a  ${trip.destino}')),
            ])));
  }

  showModal(BuildContext context, Trip? trip) {
    bool isEdit = false;

    int newId = trips.length == 0 ? 1 : trips.last.id + 1;

    String newMatricula = "";
    String newFrota = "";
    String newEmpresa = "";
    String newOrigem = "";
    String newDestino = "";
    List<LaunchTrip> launchTrips = [];

    Mask maskMatricula = Mask(
        formatter: MaskTextInputFormatter(mask: "#####"),
        hint: '',
        textInputType: TextInputType.number);

    Mask maskFrota = Mask(
        formatter: MaskTextInputFormatter(mask: ""),
        hint: '',
        textInputType: TextInputType.text);

    Mask maskEmpresa = Mask(
        formatter: MaskTextInputFormatter(mask: ""),
        hint: '',
        textInputType: TextInputType.text);

    Mask maskOrigem = Mask(
        formatter: MaskTextInputFormatter(mask: ""),
        hint: '',
        textInputType: TextInputType.text);

    Mask maskDestino = Mask(
        formatter: MaskTextInputFormatter(mask: ""),
        hint: '',
        textInputType: TextInputType.text);

    if (trip != null) {
      newId = trip.id;
      maskMatricula.textController.text = newMatricula = trip.matricula;
      maskFrota.textController.text = newFrota = trip.frota;
      maskEmpresa.textController.text = newEmpresa = trip.empresa;
      maskOrigem.textController.text = newOrigem = trip.origem;
      maskDestino.textController.text = newDestino = trip.destino;
      launchTrips = trip.launchTrips;
      isEdit = true;
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
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      inputFormatters: [
                                        maskMatricula.formatter
                                      ],
                                      controller: maskMatricula.textController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        hintText: 'Mátricula do motorista',
                                        labelText:
                                            'Informe a mátricula do motorista',
                                      ),
                                      validator: (String? value) {
                                        if (value == "") {
                                          return 'Informe a mátricula do motorista';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newMatricula = value.toUpperCase();
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      maxLength: 7,
                                      inputFormatters: [maskFrota.formatter],
                                      controller: maskFrota.textController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        hintText: 'Informe a frota',
                                        labelText: 'Frota',
                                      ),
                                      validator: (String? value) {
                                        if (value == "") {
                                          return 'Informe a frota';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newFrota = value.toUpperCase();
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      maxLength: 40,
                                      inputFormatters: [maskEmpresa.formatter],
                                      controller: maskEmpresa.textController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        hintText:
                                            'Informe a empresa do serviço',
                                        labelText: 'Empresa',
                                      ),
                                      validator: (String? value) {
                                        if (value == "") {
                                          return 'Informe a empresa do serviço';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newEmpresa = value.toUpperCase();
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      maxLength: 50,
                                      inputFormatters: [maskOrigem.formatter],
                                      controller: maskOrigem.textController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        hintText: 'Informe a Origem da Viagem',
                                        labelText: 'Origem',
                                      ),
                                      validator: (String? value) {
                                        if (value == "") {
                                          return 'Informe a origem';
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
                                      maxLength: 50,
                                      inputFormatters: [maskDestino.formatter],
                                      controller: maskDestino.textController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        hintText: 'Informe o Destino da Viagem',
                                        labelText: 'Destino',
                                      ),
                                      validator: (String? value) {
                                        if (value == "") {
                                          return 'Informe o destino';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newDestino = value;
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
                                                            if (trips == null)
                                                              trips = [];

                                                            if (isEdit)
                                                              trips.removeWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      newId);

                                                            trips.add(Trip(
                                                                id: newId,
                                                                matricula:
                                                                    newMatricula,
                                                                frota: newFrota
                                                                    .toUpperCase(),
                                                                empresa: newEmpresa
                                                                    .toUpperCase(),
                                                                origem: newOrigem
                                                                    .toUpperCase(),
                                                                destino: newDestino
                                                                    .toUpperCase(),
                                                                launchTrips:
                                                                    launchTrips));
                                                            TripService.save(
                                                                trips);
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          return;
                                                        }

                                                        /*_showDialog(switch (200) {
                        200 => 'Successfully signed in.',
                        401 => 'Unable to sign in.',
                        _ => 'Something went wrong. Please try again.'
                      });*/
                                                      })),
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

  removeItem(int sequencia) async {
    this.trips.removeWhere((item) => item.id == sequencia);
    await TripService.save(this.trips);
  }
}
