import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const HSEAcademyApp());

class HSEAcademyApp extends StatelessWidget {
  const HSEAcademyApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, title: 'HSE Academy',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    home: const AuthPage(),
  );
}

const courses = [
  ('osha','OSHA Fundamentals','OSHA, CFR, inspections and LOTO',Icons.shield),
  ('hsepro','HSE Pro: From Field to Insight','90-Day Professional HSE Development Program',Icons.engineering),
  ('iso','ISO 45001','Occupational Health & Safety Management Systems',Icons.verified_user),
  ('risk','Risk Assessment & HIRA','Identify, assess and control risks effectively',Icons.warning_amber),
  ('rca','Incident Investigation & RCA','Find root causes and prevent recurrence',Icons.search),
  ('loto','LOTO & Hazardous Energy','Isolation, lockout and verification',Icons.lock),
  ('data','HSE Data Analysis','Excel, dashboards and HSE indicators',Icons.analytics),
  ('inspection','Practical HSE Inspection','Field inspection and action tracking',Icons.fact_check),
];

const osha = [
 ('1','What is OSHA?','Purpose, scope and role of OSHA'),
 ('2','OSHA and the CFR','How OSHA standards fit into the Code of Federal Regulations'),
 ('3','General Industry / 1910','Core General Industry standards'),
 ('4','Construction / 1926','Construction standards and field application'),
 ('5','Responsibilities and Field Inspection','Employer/employee duties and inspection logic'),
 ('6','Hazardous Energy and LOTO','Lockout/Tagout fundamentals and field practice'),
];

const weeks = [
 'Cognitive biases and HSE mindset',
 'OSHA, NEBOSH, ISO 45001 and HSE indicators',
 'Hazard identification, JSA and inspection',
 '5 Whys and 5 Layers practical exercise',
 'Advanced Excel: Pivot, trends and dashboards',
 'HSE software and data interpretation',
 'ISO 45001 clauses 4–6 and gap analysis',
 'First analytical report and professional portfolio',
 'Operator networking and field information',
 'Second analytical report',
 'Power Query, pattern discovery and third report',
 'Final portfolio and professional presentation',
];

class AuthPage extends StatefulWidget {
 const AuthPage({super.key});
 @override State<AuthPage> createState()=>_AuthPageState();
}
class _AuthPageState extends State<AuthPage>{
 final e=TextEditingController(),p=TextEditingController();
 Future<void> enter() async{
  if(e.text.trim().isEmpty||p.text.isEmpty)return;
  final u=e.text.trim().toLowerCase(), sp=await SharedPreferences.getInstance();
  await sp.setString('active_user',u);
  await sp.setString('user_${u}_name',sp.getString('user_${u}_name')??u.split('@').first);
  if(mounted)Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>HomeShell(user:u)));
 }
 @override Widget build(BuildContext c)=>Scaffold(body:SafeArea(child:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:Column(children:[
  const Icon(Icons.engineering,size:72,color:Colors.green),
  const Text('HSE Academy',style:TextStyle(fontSize:32,fontWeight:FontWeight.bold)),
  const Text('Professional HSE Learning & Practice Platform'),
  const SizedBox(height:30),
  TextField(controller:e,decoration:const InputDecoration(labelText:'Email',border:OutlineInputBorder())),
  const SizedBox(height:12),
  TextField(controller:p,obscureText:true,decoration:const InputDecoration(labelText:'Password',border:OutlineInputBorder())),
  const SizedBox(height:16),
  FilledButton(onPressed:enter,child:const Text('Create account / Sign in')),
  const SizedBox(height:25),
  const Text('Founded & Developed by Mahdi Shahmoradi'),
 ]))));
}
}

class HomeShell extends StatefulWidget{
 final String user; const HomeShell({super.key,required this.user});
 @override State<HomeShell> createState()=>_HomeShellState();
}
class _HomeShellState extends State<HomeShell>{
 int i=0;
 @override Widget build(BuildContext c)=>Scaffold(
  body:IndexedStack(index:i,children:[
   HomePage(user:widget.user,onCourses:()=>setState(()=>i=1)),
   CoursesPage(user:widget.user),
   const ToolsPage(),
   ProfilePage(user:widget.user),
  ]),
  bottomNavigationBar:NavigationBar(selectedIndex:i,onDestinationSelected:(x)=>setState(()=>i=x),
   destinations:const[
    NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
    NavigationDestination(icon:Icon(Icons.menu_book_outlined),selectedIcon:Icon(Icons.menu_book),label:'Courses'),
    NavigationDestination(icon:Icon(Icons.build_outlined),selectedIcon:Icon(Icons.build),label:'Tools'),
    NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profile'),
   ]),
 );
}

class HomePage extends StatelessWidget{
 final String user; final VoidCallback onCourses;
 const HomePage({super.key,required this.user,required this.onCourses});
 @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:[
  Text('HSE Academy',style:Theme.of(c).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold)),
  Text('Hello, ${user.split('@').first}',style:Theme.of(c).textTheme.titleMedium),
  const SizedBox(height:18),
  Card(color:Colors.green.shade50,child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
   const Text('HSE Pro',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold)),
   const Text('From Field to Insight'),
   const SizedBox(height:12),const LinearProgressIndicator(value:0),
   const SizedBox(height:12),FilledButton(onPressed:onCourses,child:const Text('Continue Learning')),
  ]))),
  const SizedBox(height:18),Text('My Courses',style:Theme.of(c).textTheme.titleLarge),
  ...courses.take(5).map((x)=>Card(child:ListTile(leading:Icon(x.$4),title:Text(x.$2),subtitle:Text(x.$3),onTap:onCourses))),
 ]));
}

class CoursesPage extends StatelessWidget{
 final String user; const CoursesPage({super.key,required this.user});
 @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:[
  Text('Courses',style:Theme.of(c).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold)),
  const SizedBox(height:10),
  ...courses.map((x)=>Card(child:ListTile(leading:CircleAvatar(child:Icon(x.$4)),title:Text(x.$2),subtitle:Text(x.$3),
   trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CoursePage(user:user,id:x.$1,title:x.$2))))),
 ]));
}

class CoursePage extends StatefulWidget{
 final String user,id,title; const CoursePage({super.key,required this.user,required this.id,required this.title});
 @override State<CoursePage> createState()=>_CoursePageState();
}
class _CoursePageState extends State<CoursePage>{
 Set<String> done={};
 @override void initState(){super.initState();load();}
 Future<void> load()async{final p=await SharedPreferences.getInstance();final s=p.getString('user_${widget.user}_${widget.id}_done')??'[]';setState(()=>done=(jsonDecode(s) as List).cast<String>().toSet());}
 Future<void> toggle(String k)async{final p=await SharedPreferences.getInstance();setState(()=>done.contains(k)?done.remove(k):done.add(k));await p.setString('user_${widget.user}_${widget.id}_done',jsonEncode(done.toList()));}
 @override Widget build(BuildContext c){
  final items=widget.id=='osha'?osha.map((x)=>(x.$1,x.$2,x.$3)).toList():
   List.generate(widget.id=='hsepro'?12:6,(i)=>('${i+1}',widget.id=='hsepro'?'Week ${i+1}: ${weeks[i]}':'Module ${i+1}','Lesson + practical field exercise'));
  return Scaffold(appBar:AppBar(title:Text(widget.title)),body:ListView(padding:const EdgeInsets.all(16),children:[
   if(widget.id=='hsepro')const Text('90-Day Professional HSE Development Program\n12 Weeks • 90 Days • Project-Based',style:TextStyle(fontWeight:FontWeight.bold)),
   const SizedBox(height:14),
   ...items.map((x)=>Card(child:CheckboxListTile(value:done.contains(x.$1),onChanged:(_)=>toggle(x.$1),title:Text(x.$2),subtitle:Text(x.$3)))),
  ]));
 }
}

class ToolsPage extends StatelessWidget{
 const ToolsPage({super.key});
 @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:[
  Text('HSE Tools',style:Theme.of(c).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold)),
  ...['JSA Builder','Checklists','Risk Assessment','Incident Report','LOTO Guide','Hazardous Materials','Daily Inspection','Templates'].map((x)=>Card(child:ListTile(leading:const Icon(Icons.build),title:Text(x),onTap:()=>ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text('$x module')))))),
 ]));
}

class ProfilePage extends StatefulWidget{
 final String user; const ProfilePage({super.key,required this.user});
 @override State<ProfilePage> createState()=>_ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage>{
 final name=TextEditingController(),job=TextEditingController(),position=TextEditingController(),company=TextEditingController();
 @override void initState(){super.initState();load();}
 Future<void> load()async{final p=await SharedPreferences.getInstance();name.text=p.getString('user_${widget.user}_name')??widget.user.split('@').first;job.text=p.getString('user_${widget.user}_job')??'';position.text=p.getString('user_${widget.user}_position')??'';company.text=p.getString('user_${widget.user}_company')??'';setState((){});}
 Future<void> save()async{final p=await SharedPreferences.getInstance();await p.setString('user_${widget.user}_name',name.text);await p.setString('user_${widget.user}_job',job.text);await p.setString('user_${widget.user}_position',position.text);await p.setString('user_${widget.user}_company',company.text);if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Profile saved.')));}
 @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:[
  Center(child:CircleAvatar(radius:42,child:const Icon(Icons.person,size:42))),const SizedBox(height:12),
  ...[('Full name',name),('Job',job),('Position',position),('Company / Organization',company)].map((x)=>Padding(padding:const EdgeInsets.only(bottom:12),child:TextField(controller:x.$2,decoration:InputDecoration(labelText:x.$1,border:const OutlineInputBorder())))),
  FilledButton(onPressed:save,child:const Text('Save profile')),
  OutlinedButton.icon(onPressed:()async{await ImagePicker().pickImage(source:ImageSource.gallery);},icon:const Icon(Icons.photo),label:const Text('Choose photo')),
  const SizedBox(height:20),const Text('Founded & Developed by Mahdi Shahmoradi',textAlign:TextAlign.center),
 ]));
}
