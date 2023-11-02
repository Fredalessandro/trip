import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:trip/main.dart';
import '../component/mask.dart';
import '../component/navigation_bar.dart';
import '../model/launch_trip_model.dart';
import '../service/launch_trrip_service.dart';

class LaunchTripPage extends StatefulWidget {
  @override
  _LaunchTripState createState() => _LaunchTripState();
}

class _LaunchTripState extends State<LaunchTripPage> {
  List<LaunchTrip> trips =  List.empty();

  String local = "";
  int newSequencia = 0;
  String newOrigem = "";
  String newDia = "";
  String newHora = "";
  String newKm = "";
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
 
  @override
  void initState() {
    super.initState();
    setState(() {
      getTrips();
    });
    //remove();
  }

  Future<List<LaunchTrip>> getTrips() async {

    await LaunchTripService.get().then((value) => this.trips=value);
    
    return this.trips;

  }
  
  remove() async {
    await LaunchTripService.remove();
  }

  removeItem(int sequencia) async {
    this.trips.removeWhere((item) => item.id == sequencia);
    await LaunchTripService.save(this.trips);
  }

  bool isTrip(LaunchTrip elemento,int sequencia) {
    return (elemento.id==sequencia);
  }
  @override
  Widget build(BuildContext context) {
    
    setState(() {
      getTrips();
    });
    

    return MaterialApp( 
      
      home: Scaffold(
      appBar: AppBar(
        actions: <Widget> [
          IconButton(
              icon: Icon(Icons.manage_accounts_outlined),
              onPressed: () {
                Navigator.pushNamed(this.context, '/user'); 
              },
            ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title:
            Text('RELATÓRIO DE VIAGEM',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
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
      floatingActionButton: 
           FloatingActionButton(
              onPressed: () {
                showModal(context);
              },
              tooltip: 'Iniciar deslocamento!',
              child: const Icon(Icons.add_sharp))
          ,
    bottomNavigationBar: MyBottomNavigationBar(context: context,isHome: true)));
  }

  Widget tripItem(BuildContext context, index) {
    LaunchTrip trip = trips[index];
  return Card(
        color: Colors.blue[100] ,
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
          children: <Widget>[montaCard(context, trip)]) ,
    ));
  }

  

  Widget montaCard(BuildContext context, LaunchTrip trip) {

    local = trip.tipo == 'S' ? 'Saída' : 'Chegada';
    var localPercurso = trip.tipo == 'S' ? 'Origem' : 'Destino';
    String seq = '${trip.id}'.padLeft(2, '0');

   return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                height: 30,
                child: Center(
                    child: Text(
                  'Local de $local',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ))),
            SizedBox(height: 40, child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('Seq.: ${seq}'),          
                  trips.isNotEmpty && trips.last.id==trip.id?IconButton(
                      icon: Icon(Icons.delete_outline),
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          removeItem(trip.id);
                        });
                      },
                    ):new Text('')])),    
            SizedBox(height: 30, child: Text('${localPercurso} : ${trip.destino}')),
            SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Center(child:Row(mainAxisAlignment:  MainAxisAlignment.center,
                    
                    children: [
                    Text('Dia  :',),SizedBox(width:10,),Text('${trip.dia}'),SizedBox(width:10,),
                    Text('Hora :'),SizedBox(width: 10,),Text('${trip.hora}'),SizedBox(width:10,),
                    Text('Km   :'),SizedBox(width: 10,),Text('${trip.km}')])),
                    
                  ],
                )),
]);
  }

  showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        String localDeslocamento =
            trips.isEmpty || trips.last.tipo == 'C' ? 'Saída' : 'Chegada';
        
        //trips.isNotEmpty && trips.last.tipo == 'C'?newSequencia=trips.last.sequencia=1:newSequencia=trips.last.sequencia;

        if (!trips.isEmpty) {
          if (this.trips.last.tipo=='C') {
            newSequencia=this.trips.last.id+1;
          } else {
            newSequencia=this.trips.last.id;
          }
            
        } else newSequencia = 1;

        Mask maskDia = Mask(
            formatter: MaskTextInputFormatter(mask: "##/##/####"),
            hint: '',
            textInputType: TextInputType.datetime);
        maskDia.textController.text = newDia = _getFormattedDate();

        Mask maskHora = Mask(
            formatter: MaskTextInputFormatter(mask: "##:##"),
            hint: '',
            textInputType: TextInputType.number);
        maskHora.textController.text = newHora = _getFormattedTime();

        Mask maskDestino = Mask(
            formatter: MaskTextInputFormatter(
                mask: ""),
            hint: '',
            textInputType: TextInputType.number);
        bool isEditKm = true;
        Mask maskKm = Mask(
            formatter: MaskTextInputFormatter(mask: "########"),
            hint: '',
            textInputType: TextInputType.number);
            if(trips.isNotEmpty && trips.last.tipo == 'C') {
               maskKm.textController.text = newKm = trips.last.km;
               isEditKm = false;
            }

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ Container(
                    width: windowWidth - 85,
  color: Theme.of(context).colorScheme.primary,
  padding: EdgeInsets.all(10),
  child: Text(
    'Local de $localDeslocamento',
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
    maxLines: 1, // Define o número máximo de linhas
    overflow: TextOverflow.ellipsis, // Define como o texto deve lidar com o overflow
  ),
)]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        inputFormatters: [maskDia.formatter],
                        controller: maskDia.textController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Informe data',
                          labelText: 'data ',
                        ),
                        validator: (String? value) {
                          
                          if (value == "") {
                            
                            return 'Informe a data!';
                          
                          } /*else {
                          
                            if (!isValidDate(value!)){
                                return 'Data inválida!';
                            }

                          }*/
                          return null;
                        },
                        onChanged: (value) {
                          newDia = value;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        inputFormatters: [maskHora.formatter],
                        controller: maskHora.textController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Informe a hora',
                          labelText: 'Hora',
                        ),
                        validator: (String? value) {
                          if (value == "") {
                            return 'Informe a hora';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          newHora = value;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  inputFormatters: [maskDestino.formatter],
                  controller: maskDestino.textController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Informe o local de deslocamento',
                    labelText: 'Local',
                  ),
                  validator: (String? value) {
                    if (value == "") {
                      return 'Informe o local de deslocamento';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    newOrigem = value;
                  },
                ),
                SizedBox(width: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  enabled: isEditKm,
                  inputFormatters: [maskKm.formatter],
                  controller: maskKm.textController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Informe a quilometragem',
                    labelText: 'Km',
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            // Adicione aqui a lógica para submeter o formulário
                            Navigator.pop(context);
                          },
                          child: Text('Cancelar'),
                        )),
                    SizedBox(width: 20),
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            // Adicione aqui a lógica para submeter o formulário
                            if (_formkey.currentState!.validate()) {

                              setState(() {

                                trips.add(LaunchTrip(
                                    id: 1,
                                    destino: newOrigem.toUpperCase(),
                                    dia: newDia,
                                    hora: newHora,
                                    km: newKm,
                                    tipo:
                                        trips.isEmpty || trips.last.tipo == 'C'
                                            ? 'S'
                                            : 'C'));
                                            LaunchTripService.save(trips);
                              });
                              Navigator.pop(context);
                              return;
                            }
                          },
                          child: Text('Salvar'),
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
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

bool isGoe(String dateInit,String date) {
  final date1 = DateTime.parse(dateInit);
  final date2 = DateTime.parse(date);
  return (date1.isBefore(date2) || date1==date2);
}