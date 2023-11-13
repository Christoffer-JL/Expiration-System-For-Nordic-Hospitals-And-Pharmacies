import 'package:flutter/material.dart';

class ExpandCard extends StatefulWidget {
  final String title;
  final List<String> departments;
  final String nordicNumber;
  final String batchNumber;
  final Future<void> Function() onDelete;

  const ExpandCard({
    super.key,
    required this.title,
    required this.departments,
    required this.nordicNumber,
    required this.onDelete,
    required this.batchNumber,
  });

  @override
  DatabaseCardState createState() => DatabaseCardState();
}

class DatabaseCardState extends State<ExpandCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: const Color.fromARGB(255, 217, 217, 217),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  key: ValueKey<bool>(isExpanded),
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: const Color.fromARGB(255, 50, 189, 131),
                ),
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            title: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Varunummer:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              widget.nordicNumber,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Batchnummer:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              widget.batchNumber,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      Column(
                        children: widget.departments
                            .asMap()
                            .entries
                            .map(
                              (entry) => Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    title: Text(
                                      entry.value,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirm Deletion'),
                                              content: Text(
                                                  'Are you sure you want to delete this item?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Yes'),
                                                  onPressed: () {
                                                    widget.onDelete();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    dense: true,
                                  ),
                                  if (entry.key < widget.departments.length - 1)
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 1,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                    ],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

class ExpandCardExpire extends StatefulWidget {
  final String title;
  final String expirationDate;
  final String packaging;
  final String articleName;
  final Future<void> Function() onDelete;

  const ExpandCardExpire({
    Key? key,
    required this.title,
    required this.packaging,
    required this.onDelete,
    required this.articleName,
    required this.expirationDate,
  }) : super(key: key);

  @override
  DatabaseCardStates createState() => DatabaseCardStates();
}

class DatabaseCardStates extends State<ExpandCardExpire> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: const Color.fromARGB(255, 217, 217, 217),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  key: ValueKey<bool>(isExpanded),
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: const Color.fromARGB(255, 50, 189, 131),
                ),
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            title: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          if (isExpanded)
            const Divider(
              color: Colors.black,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                ' ${widget.articleName}  ${widget.packaging}  ${widget.expirationDate}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isExpanded
                                  ? IconButton(
                                      key: ValueKey<bool>(isExpanded),
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        widget.onDelete();
                                      },
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
