import 'package:covid_19_app/Model/world_stats.dart';
import 'package:covid_19_app/Services/stats_services.dart';
import 'package:covid_19_app/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({super.key});

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats>with TickerProviderStateMixin {
  late final AnimationController _controller=AnimationController(duration: const Duration(seconds: 3),vsync: this)..repeat();
  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }
  final colorList=<Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246)
  ];
  @override
  Widget build(BuildContext context) {
    StatsServices statsServices=StatsServices();
    return Expanded(
      child: Scaffold(
        backgroundColor: const Color(0xff666666),
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            const SizedBox(height: 20),
            FutureBuilder(future: statsServices.fetchWorldStats(),builder: (context,AsyncSnapshot<WorldStatsModel>snapshot){
              if(!snapshot.hasData){
                return const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.white,)));
              }
              else{
               return Column(children: [
                   PieChart(dataMap: {
                     "Total": double.parse(snapshot.data!.cases!.toString()),
                     "Recovered":double.parse(snapshot.data!.recovered!.toString()),
                     "Deaths":double.parse(snapshot.data!.deaths!.toString()),
                   },
                     chartValuesOptions: const ChartValuesOptions(
                       showChartValuesInPercentage: true
                     ),
                     animationDuration: const Duration(milliseconds: 1200),
                     chartRadius: 150,
                     legendOptions: const LegendOptions(
                       legendPosition: LegendPosition.left,
                       legendTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)
                     ),
                     chartType: ChartType.ring,
                     colorList: colorList,
                   ),
                   const SizedBox(height: 80,),
                   Card(
                         color: const Color(0xff666666),
                         child: Column(
                           children: [
                             ReusableRow(title: 'Total', value:snapshot.data!.cases!.toString() ),
                             ReusableRow(title: 'Recovered', value:snapshot.data!.recovered!.toString() ),
                             ReusableRow(title: 'Deaths', value:snapshot.data!.deaths!.toString()),
                             ReusableRow(title: 'Active', value:snapshot.data!.active!.toString() ),
                             ReusableRow(title: 'Critical', value:snapshot.data!.critical!.toString() ),
                             ReusableRow(title: 'Today Deaths', value:snapshot.data!.todayDeaths!.toString()),
                             ReusableRow(title: 'Today Recovered', value:snapshot.data!.todayRecovered!.toString() ),
                           ],
                         ),
                       ),
                   const SizedBox(height: 70,),
                   InkWell(onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> const CountriesList()));
                   },child: Container(height: 60,decoration: BoxDecoration(color: const Color(0xff1aa260),borderRadius: BorderRadius.circular(10)),child: const Center(child: Text('Track Countries',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),))
                 ],);
              }
            }),
          ],),
        )),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title,value;
  ReusableRow({super.key,required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
              Text(value,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            ],
          ),
          const SizedBox(height: 5,),
          const Divider()
        ],
      ),
    );
  }
}
