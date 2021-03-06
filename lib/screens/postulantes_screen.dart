import 'package:flutter/material.dart';
import 'package:master_jobz/models/postulantes_response.dart';


import 'package:master_jobz/peticiones/jobs.dart';
import 'package:master_jobz/peticiones/postulantes.dart';
import 'package:master_jobz/screens/profile_screen.dart';
import 'package:master_jobz/widgets/pageroute.dart';

import 'package:provider/provider.dart';


class PostulantesScreen extends StatefulWidget {

  @override
  _PostulantesScreenState createState() => _PostulantesScreenState();
}

class _PostulantesScreenState extends State<PostulantesScreen> with AutomaticKeepAliveClientMixin  {
  final postulantesProvider = Postulantes();

  List<Postulante> postulantes = [];
  @override
  void initState() { 
    // _cargarPostulantes();
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    final postulantesProvider = Provider.of<Postulantes>(context);
    postulantes = postulantesProvider.postulantes;
    return Scaffold(
    
      body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Text('Postulantes', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: ( _ , i) => SizedBox(height: 20,),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: postulantes.length,
                      itemBuilder: ( context , i) {
                        
                      return Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                            offset: Offset(0,2),
                            spreadRadius: 0.2,
                          )]
                        ),
                        child: Center(
                          child: ListTile(
                            onTap: (){
                              postulantesProvider.postulante = postulantes[i];
                              Navigator.push(context,
                              ruta(ProfileScreen(), Offset(0,2),true)
                              
                              );
                            },
                            leading:Icon(Icons.account_circle, size: 60, color: Color(0xffEA5D60),) ,
                            subtitle: Text('${postulantes[i].usuario.email}'),
                            title: Text('${postulantes[i].usuario.nombre}'),
                          ),
                        ),
                      );
                    } ),
                  ),
                ],
              ),
            ),
          ),
   );
  }

  Future _cargarPostulantes() async{
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    postulantes = await postulantesProvider.getPostulantes(jobProvider.job!.id);
    print(postulantes);
    if(!mounted){
      return;
    }
    setState(() {
      
    });

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}