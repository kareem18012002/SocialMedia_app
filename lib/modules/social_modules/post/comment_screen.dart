import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/shared/styles/icon_broken.dart';
import '../../../models/comment_model.dart';
import '../../../shared/cubit/social/cubit.dart';
import '../../../shared/cubit/social/state.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen(this.postId,{Key? key}) : super(key: key);
  var textController = TextEditingController();
   String? postId;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getComment(postId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: const Text('Comments'),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        IconBroken.Heart,
                        color: Colors.red,
                      ))
                ],
              ),
              body: ConditionalBuilder(
                condition: SocialCubit.get(context).comments.isNotEmpty,
                builder: (BuildContext context) => Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildCommentItem(context,SocialCubit.get(context).comments[index],postId);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15.0,
                          ),
                          itemCount: SocialCubit.get(context).comments.length,
                        ),
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
                                  hintText: 'Send a new Comment',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {

                                SocialCubit.get(context).sendComment(
                                    text: textController.text,
                                    dateTime: DateTime.now().toString(),
                                    postId: postId
                                );
                                textController.clear();
                                SocialCubit.get(context).getPost();
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
                                  hintText: 'Send a new Comment',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                SocialCubit.get(context).sendComment(
                                    text: textController.text,
                                    dateTime: DateTime.now().toString(),
                                    postId: postId
                                );
                                textController.clear();
                                SocialCubit.get(context).getPost();
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
      }
    );
  }

  Widget buildCommentItem(context,CommentModel model,postId) => Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${model.image}',
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.name}',
                        style: const TextStyle(
                            height: 1.4, fontWeight: FontWeight.bold),
                      ),
                       Text(
                        '${model.text}',
                        style: const TextStyle(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}
