import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_shop/bloc/product_cubit.dart';
import 'package:mini_shop/bloc/theme_cubit.dart';
import 'package:mini_shop/views/screens/homepage.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MainRunner());
}

class MainRunner extends StatelessWidget {
  const MainRunner({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(builder: (context, state) {
        return MaterialApp(
          theme: state ? ThemeData.dark() : ThemeData.light(),
          debugShowCheckedModeBanner: false,
          home: Homepage(),
        );
      }),
    );
  } 
}
