import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utility_screens/new_blog.dart';
import '../utility_screens/readblog.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key});

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {


  List<String> words = [
    'Adjuvant Chemotherapy:',
    'Adenoma:'              ,
    'Adjuvant Therapy:'     ,
    'Alopecia:'             ,
    'Amenorrhea:'           ,
    'Anastrazole:'          ,
    'Anemia:'               ,
    'Angiogenesis:'         ,
    'Anorexia:'             ,
    'Aspiration:'           ,
    'Autologous transplant:',
    'Biopsy:'               ,
    'Bone marrow transplant:'   ,
    'BRCA1 and BRCA2:'          ,
    'Breast-conserving therapy:',
    'Calcifications:'           ,
    'Chemoprevention:'          ,
    'Cyst:'                     ,
    'Cytoxan:'                  ,
    'Ductal carcinoma in situ (DCIS):',
    'Estrogen receptor (ER) test:'    ,
    'FNA (fine needle aspiration):'   ,
    'Frozen section:'                 ,
    'Immunotherapy:'                  ,
    'Infiltrating cancer:'            ,
    'Inflammatory breast cancer:'     ,
    'Mucositis, gastritis:'           ,
    'Myeloma:'                        ,
    'Taxol:'                          ,
    'Taxotere:'                       ,
    'Total mastectomy:'               ,
    'Atypical Hyperplasia:'           ,
    'Axillary Dissection (Axillary Sampling):',
    'Bisphosphonates:'                        ,
    'Cancer Rehabilitation:'                  ,
    'Complementary Therapies (Integrative Therapies):',
    'Diabetic Mastopathy:'                            ,
    'Diagnostic Mammogram:'
  ];
  List<String> definitions = [
    'Anti-cancer drugs used in combination with surgery and/or radiation to destroy residual cancer cells to prevent or delay recurrence.'                                                                                                                                                                                ,
    "Adenoma is a type of non-cancerous tumor or benign that may affect various organs. It is derived from the word “adeno” meaning 'pertaining to a gland'."                                                                                                                                                             ,
    'Treatment that is given before there is any indication that the cancer has spread to prevent or delay the development of metastatic breast cancer administered after surgery and/or radiation.'                                                                                                                      ,
    'Hair follicles are the structures in skin that form hair. While hair can be lost from any part of the body, alopecia areata usually affects the head and face.'                                                                                                                                                      ,
    'Amenorrhea is when you don’t get your menstrual period. There are two kinds of amenorrhea: primary and secondary. Primary amenorrhea is when a person older than 15 has never gotten their first period. Secondary amenorrhea happens when a person doesn’t get a period for more than three months.'                ,
    'Anastrozole is in a class of medications called nonsteroidal aromatase inhibitors. It works by decreasing the amount of estrogen the body makes. This can slow or stop the growth of many types of breast cancer cells that need estrogen to grow. A hormone therapy for advanced breast cancer'                     ,
    'Condition in which a decreased number of red blood cells may cause symptoms including tiredness, shortness of breath, and weakness.'                                                                                                                                                                                 ,
    'The process of development of new blood vessels. In cancer, the development of blood vessels can feed tumors and allow them to grow, and drugs that block angiogenesis are being tested as cancer treatment.'                                                                                                        ,
    "The medical term for a loss of appetite is anorexia. When you have a loss of appetite, you don't feel hungry. Anorexia isn't the same as the eating disorder anorexia nervosa. A person diagnosed with anorexia nervosa may feel hungry but restricts food intake."                                                  ,
    'A technique for removing fluid from a cyst or cells from a mass, using a needle and syringe.'                                                                                                                                                                                                                        ,
    'The reintroduction of cells, tissue or organ previously removed from an individual, back into the same individual with continued function after reintroduction.'                                                                                                                                                     ,                                          
    'The removal of a sample of abnormal tissue that is microscopically examined for cancer cells.'                                                                                                                                                                                                                       ,
    "A procedure in which physicians replace marrow destroyed by high doses of anti-cancer drugs or radiation. The replacement marrow may be taken from the patient before treatment or may be donated by another person. When the patient's own marrow is used the procedure is called autologous bone marrow transplant.",
    "The principal genes that, when abnormal, or mutated, indicate an inherited susceptibility to breast and ovarian cancers; accounting for 80-90% of all inherited cases of breast and the majority of inherited ovarian cancers."                                                                                       ,
    'A treatment for breast cancer in which the breast is preserved, it usually consists of segmental mastectomy , lumpectomy and radiation therapy.'                                                                                                                                                                      ,
    'Breast calcifications are calcium deposits within breast tissue. They appear as white spots or flecks on a mammogram. Breast calcifications are common on mammograms.'                                                                                                                                                ,
    'The use of drugs or vitamins to prevent cancer in people who have precancerous conditions or a high risk of cancer, or to prevent the recurrence of cancer in people who already have been treated for it.'                                                                                                           ,                                                      
    "Some cysts are too small to feel, while others grow up to several inches — large enough for you to feel and even make you uncomfortable. Clusters of cysts can form in one breast or both. Breast cysts don't increase your risk of developing breast cancer. They also don't “turn into” anything more serious"      ,
    "A chemotherapy drug commonly used in breast and other cancers."                                                                                                                                                                                                                                                       ,
    "Cancer cells that develop from the lining of the milk duct but are confined to the ducts of the breast. DCIS is considered to be a precursor to invasive cancer, and almost never spreads beyond the breast."                                                                                                         ,
    "test done on tumor tissue to determine if a tumor is sensitive to estrogen (ER positive), and thus whether hormone therapy may be effective."                                                                                                                                                                         ,
    "Biopsy in which cells are removed from a lump by needle and syringe, and then tested to see if cancer cells are present."                                                                                                                                                                                             ,
    "A sliver of frozen biopsy tissue, used for immediate diagnosis at the time of surgery."                                                                                                                                                                                                                               , 
    "Genetically reengineered genes are used to boost the immune system.It is designed to act only on the cancer cells, so there is no adverse effect on normal cells, thus there are no adverse side effects."                                                                                                            ,                           
    "Cancer that has grown beyond its site of origin into neighboring tissue. Does not imply that the cancer has spread outside the breast."                                                                                                                                                                               ,
    "Uncommon type of cancer in which cancer cells block the lymph vessels of the breast. Blockage causes the breast to become red, swollen and warm with a dimpled (like an orange) appearance to the skin."                                                                                                              ,
    "Inflammation of the mucous membrane, especially that of the stomach."                                                                                                                                                                                                                                                 ,
    "A malignant tumor of the bone marrow associated with the production of abnormal proteins."                                                                                                                                                                                                                            ,
    "A chemotherapy commonly used to treat breast cancer."                                                                                                                                                                                                                                                                 ,
    "A chemotherapy used to treat advanced breast cancer."                                                                                                                                                                                                                                                                 ,
    "Surgery to remove the entire breast including the nipple, but not the axillary lymph nodes."                                                                                                                                                                                                                          ,
    "A benign (not cancer) breast condition where breast cells are growing rapidly (proliferating). The proliferating cells look abnormal under a microscope. Although atypical hyperplasia is not breast cancer, it increases the risk of breast cancer."                                                                 ,
    "Surgical procedure to remove some or all of the lymph nodes from the underarm area so the nodes can be examined under a microscope to check whether cancer cells are present."                                                                                                                                        ,
    "Bone density medications used to help prevent bone loss (osteoporosis). These drugs can be used to lower the risk of breast cancer recurrence in some women with early breast cancer. They are also used to strengthen bones and decrease the rate of bone fractures and pain due to breast cancer metastases to the bone.",
    "Programs that help people with cancer improve their quality of life by regaining physical strength and emotional well-being during and after cancer treatment. These programs help people stay active in their home and work lives and may include exercise, nutrition counseling and pain management."                    ,
    "Therapies (such as acupuncture or massage) used in addition to standard medical treatments. Complementary therapies are not used to treat cancer, but they may help improve quality of life and relieve some side effects of treatment or the cancer itself. When complementary therapies are combined with standard medical care, they are often called integrative therapies.",
    "A rare benign (not cancer) breast condition that consists of small, hard masses in the breast. It occurs most often in women with insulin-dependent (type 1) diabetes."                                                                                                                                                                                                         ,
    "A mammogram used to check symptoms of breast cancer (such as a lump) or an abnormal finding on a screening mammogram or clinical breast exam. It involves 2 or more views of the breast."
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  convertTime(Timestamp timestamp){
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  convertDate(DateTime dateTime){
    String date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    return date;
  }

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int random_num = random.nextInt(definitions.length);
    double screen_width = MediaQuery.of(context).size.width;

    if(screen_width > 500){
      return Scaffold(
        //extendBody: true,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          //controller: _controller,
          child: Center(
            child: Container(
              color: Colors.white,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Read Blogs and Discover',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey.shade800

                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text('Read and Watch!',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13.0,right: 4),
                                  child: Icon(Icons.notifications_none, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('Jargon Word of the Day',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800

                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.pinkAccent,
                                ),
                                width: MediaQuery.of(context).size.width - 50,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 5),
                                          child: Text(
                                            words[random_num],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0,right: 10),
                                          child: Text(
                                            definitions[random_num],
                                            softWrap: true,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              //fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),

                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0,bottom: 10),
                              child: Text('Top Blogs',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800
                                ),
                              ),
                            ),
                            Container(
                              height: 250,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                  }

                                  var blogs = snapshot.data!.docs;

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: blogs.length,
                                    itemBuilder: (context, index) {
                                      var blog = blogs[index];
                                      var blogTitle = blog['title'];
                                      var blogContent = blog['content'];
                                      var blogAuthor = blog['authorName'];
                                      var blogDate = "${convertDate(blog['timestamp'].toDate())}   \n At : ${convertTime(blog['timestamp'])}";
                                      var blogAuthorPhotoUrl = blog['authorPhotoUrl'];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReadBlog(
                                                blog_title: blogTitle,
                                                blog_content: blogContent,
                                                blog_author: blogAuthor,
                                                blog_date: blogDate,
                                                blog_author_url: blogAuthorPhotoUrl,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 200,
                                              width: 400,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    spreadRadius: 3,
                                                    blurRadius: 6,
                                                    offset: Offset(1, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 20,
                                                              backgroundImage: blogAuthorPhotoUrl != null
                                                                  ? NetworkImage(blogAuthorPhotoUrl)
                                                                  : AssetImage('assets/user.png'),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(blogAuthor),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 8.0),
                                                          child: Text(
                                                            "On: ${convertDate(blog['timestamp'].toDate())}  At : ${convertTime(blog['timestamp'])}",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.grey.shade700,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      blogTitle,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: 14,
                                                        color: Colors.grey.shade700,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      blogContent,
                                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  NewBlog()),
                                        );
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                              spreadRadius: 3, // How much the shadow spreads
                                              blurRadius: 6, // How blurry the shadow is
                                              offset: Offset(1, 1), // Changes the position of the shadow
                                            ),
                                          ],
                                        ),
                                        child: Icon(Icons.add,color: Colors.grey.shade500,),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("New Blog",style: TextStyle(color: Colors.grey.shade700),),
                                    Container(
                                      height: MediaQuery.of(context).size.height,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),


      );
    } else {
      return Scaffold(
        //extendBody: true,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          //controller: _controller,
          child: Center(
            child: Container(
              color: Colors.white,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Read Blogs and Discover',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey.shade800

                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text('Read and Watch!',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13.0,right: 4),
                                  child: Icon(Icons.notifications_none, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('Jargon Word of the Day',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800

                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.pinkAccent,
                                ),
                                width: MediaQuery.of(context).size.width - 50,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 5),
                                          child: Text(
                                            words[random_num],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0,right: 10),
                                          child: Text(
                                            definitions[random_num],
                                            softWrap: true,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              //fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),

                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0,bottom: 10),
                              child: Text('Top Blogs',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade800
                                ),
                              ),
                            ),
                            Container(
                              height: 250,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                  }

                                  var blogs = snapshot.data!.docs;

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: blogs.length,
                                    itemBuilder: (context, index) {
                                      var blog = blogs[index];
                                      var blogTitle = blog['title'];
                                      var blogContent = blog['content'];
                                      var blogAuthor = blog['authorName'];
                                      var blogDate = "${convertDate(blog['timestamp'].toDate())}   \n At : ${convertTime(blog['timestamp'])}";
                                      var blogAuthorPhotoUrl = blog['authorPhotoUrl'];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReadBlog(
                                                blog_title: blogTitle,
                                                blog_content: blogContent,
                                                blog_author: blogAuthor,
                                                blog_date: blogDate,
                                                blog_author_url: blogAuthorPhotoUrl,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 200,
                                              width: MediaQuery.of(context).size.width - 100,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    spreadRadius: 3,
                                                    blurRadius: 6,
                                                    offset: Offset(1, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 20,
                                                              backgroundImage: blogAuthorPhotoUrl != null
                                                                  ? NetworkImage(blogAuthorPhotoUrl)
                                                                  : AssetImage('assets/user.png'),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(blogAuthor),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 8.0),
                                                          child: Text(
                                                            "On: ${convertDate(blog['timestamp'].toDate())}  At : ${convertTime(blog['timestamp'])}",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.grey.shade700,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      blogTitle,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: 14,
                                                        color: Colors.grey.shade700,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      blogContent,
                                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  NewBlog()),
                                        );
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                              spreadRadius: 3, // How much the shadow spreads
                                              blurRadius: 6, // How blurry the shadow is
                                              offset: Offset(1, 1), // Changes the position of the shadow
                                            ),
                                          ],
                                        ),
                                        child: Icon(Icons.add,color: Colors.grey.shade500,),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("New Blog",style: TextStyle(color: Colors.grey.shade700),),
                                    Container(
                                      height: MediaQuery.of(context).size.height,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),


      );
    }
  }
}
