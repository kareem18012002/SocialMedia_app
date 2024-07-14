import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/models/massage_model.dart';
import 'package:socialapp/models/user_model.dart';
import 'package:socialapp/shared/styles/icon_broken.dart';

import '../../../shared/cubit/social/cubit.dart';
import '../../../shared/cubit/social/state.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({Key? key,  this.userModel}) : super(key: key);
  UserModel? userModel;
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMassages(receiverId: userModel?.uId);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                          '${userModel?.image}',
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        '${userModel?.name}',
                        style: const TextStyle(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: ConditionalBuilder(
              condition: SocialCubit.get(context).massages.isNotEmpty,
              builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var massage = SocialCubit.get(context).massages[index];
                            if(SocialCubit.get(context).userModel?.uId == massage.senderId) {
                              return buildMyMassage(massage);
                            }

                              return buildMassage(massage);
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 15,),
                          itemCount: SocialCubit.get(context).massages.length),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadiusDirectional.circular(15)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      padding: const EdgeInsetsDirectional.only(start: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: textController,
                              decoration: const InputDecoration(
                                hintText: 'Send a new Massage',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              SocialCubit.get(context).sendMassage(
                                  text: textController.text,
                                  dateTime: DateTime.now().toString(),
                                  receiverId: userModel?.uId);
                              textController.clear();
                            },
                            color: Colors.blue,
                            minWidth: 1,
                            height: 50,
                            child: const Icon(IconBroken.Send),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              fallback: (BuildContext context) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const Spacer(),
                    const Center(child: CircularProgressIndicator()),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadiusDirectional.circular(15)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      padding: const EdgeInsetsDirectional.only(start: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: textController,
                              decoration: const InputDecoration(
                                hintText: 'Send a new Massage',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              SocialCubit.get(context).sendMassage(
                                  text: textController.text,
                                  dateTime: DateTime.now().toString(),
                                  receiverId: userModel?.uId);
                              textController.clear();
                            },
                            color: Colors.blue,
                            minWidth: 1,
                            height: 50,
                            child: const Icon(IconBroken.Send),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildMassage(MassageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(15),
                topEnd: Radius.circular(15),
                bottomEnd: Radius.circular(15),
              )),
          child:  Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('${model.text}'),
          ),
        ),
      );

  Widget buildMyMassage(MassageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green.withOpacity(.3),
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(15),
                topEnd: Radius.circular(15),
                bottomStart: Radius.circular(15),
              )),
          child:  Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('${model.text}'),
          ),
        ),
      );
}
