'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "88654a34d029f639d7d3c27ad370fafe",
"assets/AssetManifest.bin.json": "935452b4e3bbae1a42835c436398b2e7",
"assets/AssetManifest.json": "3a4a14adf5f58f6498e7fdcbea0870a1",
"assets/assets/android12_splash.png": "a4eb09dd4d82ada49ecb4428029e4a59",
"assets/assets/captcha.html": "c35690741b926a00efffeea894e79ece",
"assets/assets/chat.png": "004bad35afcb298102c1e78ed2aeead9",
"assets/assets/chat_active.png": "fa25b2f3a0f20b94215e7859e09119e1",
"assets/assets/contact.png": "5cd80742438ce60a5f97bbb74c06b78a",
"assets/assets/contact_active.png": "ba040df5d0fe2799e55565d3c4494544",
"assets/assets/icon.png": "18d2b4db60b73f4ae7258fb90a214674",
"assets/assets/logo.png": "d39577c8558a8992fc8b5460e351b486",
"assets/assets/profile.png": "e19056f60bab55299977458f87977ab3",
"assets/assets/profile_active.png": "1ca9313390fe37538dafa0a7e3b0c163",
"assets/assets/qq.png": "6e9fc9ea51fdc33271a4a45e42dabc30",
"assets/assets/qq_qr.png": "02e697ef8728334d9c4b00ee095cfd11",
"assets/assets/splash_new.jpg": "dae6da54056cabdbdb6559f5da77b2ca",
"assets/assets/splash_new.psd": "b90ae2ca5d8412c0b54f5c8c3cfd08a4",
"assets/assets/telegram.png": "6e1b3899d5f2c889a0fdf635ec7438d0",
"assets/assets/trtc.png": "8fda5a99342bc938edd8917f3fe68e75",
"assets/assets/trtcchat.png": "87b5d62291f8148f4e7fdd90203b2568",
"assets/assets/wechat.png": "b5fa3091ca2a5b4e1272a53923891abd",
"assets/assets/wechat_qr.png": "96bdd8f44bdf2b3943e8421c595ed936",
"assets/assets/whatsapp.png": "4f9fa817d52a9ffbf7f98133a3840020",
"assets/FontManifest.json": "ca49d3b86b59a2878cf524ce5bb7f045",
"assets/fonts/MaterialIcons-Regular.otf": "a326aaaa9bef2fe57c5d6970cceea5d5",
"assets/NOTICES": "e1835177c1fc23c089938b3a84963579",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "c28258a333ec8e53a688ad074fd53c9c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "cc6f06db752ac09739bf9a88225a6af6",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "d555d8e807b1e6d29dccdceeb0c8b3d2",
"assets/packages/intl_phone_number_input/assets/flags/ad.png": "384e9845debe9aca8f8586d9bedcb7e6",
"assets/packages/intl_phone_number_input/assets/flags/ae.png": "792efc5eb6c31d780bd34bf4bad69f3f",
"assets/packages/intl_phone_number_input/assets/flags/af.png": "220f72ed928d9acca25b44793670a8dc",
"assets/packages/intl_phone_number_input/assets/flags/ag.png": "6094776e548442888a654eb7b55c9282",
"assets/packages/intl_phone_number_input/assets/flags/ai.png": "d6ea69cfc53b925fee020bf6e3248ca8",
"assets/packages/intl_phone_number_input/assets/flags/al.png": "f27337407c55071f6cbf81a536447f9e",
"assets/packages/intl_phone_number_input/assets/flags/am.png": "aaa39141fbc80205bebaa0200b55a13a",
"assets/packages/intl_phone_number_input/assets/flags/an.png": "4e4b90fbca1275d1839ca5b44fc51071",
"assets/packages/intl_phone_number_input/assets/flags/ao.png": "1c12ddef7226f1dd1a79106baee9f640",
"assets/packages/intl_phone_number_input/assets/flags/aq.png": "216d1b34c9e362af0444b2e72a6cd3ce",
"assets/packages/intl_phone_number_input/assets/flags/ar.png": "3bd245f8c28f70c9ef9626dae27adc65",
"assets/packages/intl_phone_number_input/assets/flags/as.png": "5e47a14ff9c1b6deea5634a035385f80",
"assets/packages/intl_phone_number_input/assets/flags/at.png": "570c070177a5ea0fe03e20107ebf5283",
"assets/packages/intl_phone_number_input/assets/flags/au.png": "9babd0456e7f28e456b24206d13d7d8b",
"assets/packages/intl_phone_number_input/assets/flags/aw.png": "e22cbb318a7070c92f2ab4bfdc2b0118",
"assets/packages/intl_phone_number_input/assets/flags/ax.png": "ec2062c36f09ed8fb90ac8992d010024",
"assets/packages/intl_phone_number_input/assets/flags/az.png": "6ffa766f6883d2d3d350cdc22a062ca3",
"assets/packages/intl_phone_number_input/assets/flags/ba.png": "d415bad33b35de3f095177e8e86cbc82",
"assets/packages/intl_phone_number_input/assets/flags/bb.png": "a8473747387e4e7a8450c499529f1c93",
"assets/packages/intl_phone_number_input/assets/flags/bd.png": "86a0e4bd8787dc8542137a407e0f987f",
"assets/packages/intl_phone_number_input/assets/flags/be.png": "7e5e1831cdd91935b38415479a7110eb",
"assets/packages/intl_phone_number_input/assets/flags/bf.png": "63f1c67fca7ce8b52b3418a90af6ad37",
"assets/packages/intl_phone_number_input/assets/flags/bg.png": "1d24bc616e3389684ed2c9f18bcb0209",
"assets/packages/intl_phone_number_input/assets/flags/bh.png": "264498589a94e5eeca22e56de8a4f5ee",
"assets/packages/intl_phone_number_input/assets/flags/bi.png": "adda8121501f0543f1075244a1acc275",
"assets/packages/intl_phone_number_input/assets/flags/bj.png": "6fdc6449f73d23ad3f07060f92db4423",
"assets/packages/intl_phone_number_input/assets/flags/bl.png": "dae94f5465d3390fdc5929e4f74d3f5f",
"assets/packages/intl_phone_number_input/assets/flags/bm.png": "3c19361619761c96a0e96aabadb126eb",
"assets/packages/intl_phone_number_input/assets/flags/bn.png": "ed650de06fff61ff27ec92a872197948",
"assets/packages/intl_phone_number_input/assets/flags/bo.png": "15c5765e4ad6f6d84a9a9d10646a6b16",
"assets/packages/intl_phone_number_input/assets/flags/bq.png": "3649c177693bfee9c2fcc63c191a51f1",
"assets/packages/intl_phone_number_input/assets/flags/br.png": "5093e0cd8fd3c094664cd17ea8a36fd1",
"assets/packages/intl_phone_number_input/assets/flags/bs.png": "2b9540c4fa514f71911a48de0bd77e71",
"assets/packages/intl_phone_number_input/assets/flags/bt.png": "3cfe1440e952bc7266d71f7f1454fa23",
"assets/packages/intl_phone_number_input/assets/flags/bv.png": "33bc70259c4908b7b9adeef9436f7a9f",
"assets/packages/intl_phone_number_input/assets/flags/bw.png": "fac8b90d7404728c08686dc39bab4fb3",
"assets/packages/intl_phone_number_input/assets/flags/by.png": "beabf61e94fb3a4f7c7a7890488b213d",
"assets/packages/intl_phone_number_input/assets/flags/bz.png": "756b19ec31787dc4dac6cc19e223f751",
"assets/packages/intl_phone_number_input/assets/flags/ca.png": "81e2aeafc0481e73f76dc8432429b136",
"assets/packages/intl_phone_number_input/assets/flags/cc.png": "31a475216e12fef447382c97b42876ce",
"assets/packages/intl_phone_number_input/assets/flags/cd.png": "5b5f832ed6cd9f9240cb31229d8763dc",
"assets/packages/intl_phone_number_input/assets/flags/cf.png": "263583ffdf7a888ce4fba8487d1da0b2",
"assets/packages/intl_phone_number_input/assets/flags/cg.png": "eca97338cc1cb5b5e91bec72af57b3d4",
"assets/packages/intl_phone_number_input/assets/flags/ch.png": "a251702f7760b0aac141428ed60b7b66",
"assets/packages/intl_phone_number_input/assets/flags/ci.png": "7f5ca3779d5ff6ce0c803a6efa0d2da7",
"assets/packages/intl_phone_number_input/assets/flags/ck.png": "f390a217a5e90aee35f969f2ed7c185f",
"assets/packages/intl_phone_number_input/assets/flags/cl.png": "6735e0e2d88c119e9ed1533be5249ef1",
"assets/packages/intl_phone_number_input/assets/flags/cm.png": "42d52fa71e8b4dbb182ff431749e8d0d",
"assets/packages/intl_phone_number_input/assets/flags/cn.png": "040539c2cdb60ebd9dc8957cdc6a8ad0",
"assets/packages/intl_phone_number_input/assets/flags/co.png": "e3b1be16dcdae6cb72e9c238fdddce3c",
"assets/packages/intl_phone_number_input/assets/flags/cr.png": "08cd857f930212d5ed9431d5c1300518",
"assets/packages/intl_phone_number_input/assets/flags/cu.png": "f41715bd51f63a9aebf543788543b4c4",
"assets/packages/intl_phone_number_input/assets/flags/cv.png": "9b1f31f9fc0795d728328dedd33eb1c0",
"assets/packages/intl_phone_number_input/assets/flags/cw.png": "6c598eb0d331d6b238da57055ec00d33",
"assets/packages/intl_phone_number_input/assets/flags/cx.png": "8efa3231c8a3900a78f2b51d829f8c52",
"assets/packages/intl_phone_number_input/assets/flags/cy.png": "f7175e3218b169a96397f93fa4084cac",
"assets/packages/intl_phone_number_input/assets/flags/cz.png": "73ecd64c6144786c4d03729b1dd9b1f3",
"assets/packages/intl_phone_number_input/assets/flags/de.png": "5d9561246523cf6183928756fd605e25",
"assets/packages/intl_phone_number_input/assets/flags/dj.png": "078bd37d41f746c3cb2d84c1e9611c55",
"assets/packages/intl_phone_number_input/assets/flags/dk.png": "abcd01bdbcc02b4a29cbac237f29cd1d",
"assets/packages/intl_phone_number_input/assets/flags/dm.png": "e4b9f0c91ed8d64fe8cb016ada124f3d",
"assets/packages/intl_phone_number_input/assets/flags/do.png": "fae653f4231da27b8e4b0a84011b53ad",
"assets/packages/intl_phone_number_input/assets/flags/dz.png": "132ceca353a95c8214676b2e94ecd40f",
"assets/packages/intl_phone_number_input/assets/flags/ec.png": "c1ae60d080be91f3be31e92e0a2d9555",
"assets/packages/intl_phone_number_input/assets/flags/ee.png": "e242645cae28bd5291116ea211f9a566",
"assets/packages/intl_phone_number_input/assets/flags/eg.png": "311d780e8e3dd43f87e6070f6feb74c7",
"assets/packages/intl_phone_number_input/assets/flags/eh.png": "515a9cf2620c802e305b5412ac81aed2",
"assets/packages/intl_phone_number_input/assets/flags/er.png": "8ca78e10878a2e97c1371b38c5d258a7",
"assets/packages/intl_phone_number_input/assets/flags/es.png": "654965f9722f6706586476fb2f5d30dd",
"assets/packages/intl_phone_number_input/assets/flags/et.png": "57edff61c7fddf2761a19948acef1498",
"assets/packages/intl_phone_number_input/assets/flags/eu.png": "c58ece3931acb87faadc5b940d4f7755",
"assets/packages/intl_phone_number_input/assets/flags/fi.png": "3ccd69a842e55183415b7ea2c04b15c8",
"assets/packages/intl_phone_number_input/assets/flags/fj.png": "214df51718ad8063b93b2a3e81e17a8b",
"assets/packages/intl_phone_number_input/assets/flags/fk.png": "a694b40c9ded77e33fc5ec43c08632ee",
"assets/packages/intl_phone_number_input/assets/flags/fm.png": "d571b8bc4b80980a81a5edbde788b6d2",
"assets/packages/intl_phone_number_input/assets/flags/fo.png": "2c7d9233582e83a86927e634897a2a90",
"assets/packages/intl_phone_number_input/assets/flags/fr.png": "134bee9f9d794dc5c0922d1b9bdbb710",
"assets/packages/intl_phone_number_input/assets/flags/ga.png": "b0e5b2fa1b7106c7652a955db24c11c4",
"assets/packages/intl_phone_number_input/assets/flags/gb-eng.png": "0d9f2a6775fd52b79e1d78eb1dda10cf",
"assets/packages/intl_phone_number_input/assets/flags/gb-nir.png": "3eb22f21d7c402d315e10948fd4a08cc",
"assets/packages/intl_phone_number_input/assets/flags/gb-sct.png": "75106a5e49e3e16da76cb33bdac102ab",
"assets/packages/intl_phone_number_input/assets/flags/gb-wls.png": "d7d7c77c72cd425d993bdc50720f4d04",
"assets/packages/intl_phone_number_input/assets/flags/gb.png": "ad7fed4cea771f23fdf36d93e7a40a27",
"assets/packages/intl_phone_number_input/assets/flags/gd.png": "7a4864ccfa2a0564041c2d1f8a13a8c9",
"assets/packages/intl_phone_number_input/assets/flags/ge.png": "6fbd41f07921fa415347ebf6dff5b0f7",
"assets/packages/intl_phone_number_input/assets/flags/gf.png": "83c6ef012066a5bfc6e6704d76a14f40",
"assets/packages/intl_phone_number_input/assets/flags/gg.png": "eed435d25bd755aa7f9cd7004b9ed49d",
"assets/packages/intl_phone_number_input/assets/flags/gh.png": "b35464dca793fa33e51bf890b5f3d92b",
"assets/packages/intl_phone_number_input/assets/flags/gi.png": "446aa44aaa063d240adab88243b460d3",
"assets/packages/intl_phone_number_input/assets/flags/gl.png": "b79e24ee1889b7446ba3d65564b86810",
"assets/packages/intl_phone_number_input/assets/flags/gm.png": "7148d3715527544c2e7d8d6f4a445bb6",
"assets/packages/intl_phone_number_input/assets/flags/gn.png": "b2287c03c88a72d968aa796a076ba056",
"assets/packages/intl_phone_number_input/assets/flags/gp.png": "134bee9f9d794dc5c0922d1b9bdbb710",
"assets/packages/intl_phone_number_input/assets/flags/gq.png": "4286e56f388a37f64b21eb56550c06d9",
"assets/packages/intl_phone_number_input/assets/flags/gr.png": "ec11281d7decbf07b81a23a72a609b59",
"assets/packages/intl_phone_number_input/assets/flags/gs.png": "14948849c313d734e2b9e1059f070a9b",
"assets/packages/intl_phone_number_input/assets/flags/gt.png": "706a0c3b5e0b589c843e2539e813839e",
"assets/packages/intl_phone_number_input/assets/flags/gu.png": "13fad1bad191b087a5bb0331ef5de060",
"assets/packages/intl_phone_number_input/assets/flags/gw.png": "05606b9a6393971bd87718b809e054f9",
"assets/packages/intl_phone_number_input/assets/flags/gy.png": "159a260bf0217128ea7475ba5b272b6a",
"assets/packages/intl_phone_number_input/assets/flags/hk.png": "4b5ec424348c98ec71a46ad3dce3931d",
"assets/packages/intl_phone_number_input/assets/flags/hm.png": "e5eeb261aacb02b43d76069527f4ff60",
"assets/packages/intl_phone_number_input/assets/flags/hn.png": "9ecf68aed83c4a9b3f1e6275d96bfb04",
"assets/packages/intl_phone_number_input/assets/flags/hr.png": "69711b2ea009a3e7c40045b538768d4e",
"assets/packages/intl_phone_number_input/assets/flags/ht.png": "630f7f8567d87409a32955107ad11a86",
"assets/packages/intl_phone_number_input/assets/flags/hu.png": "281582a753e643b46bdd894047db08bb",
"assets/packages/intl_phone_number_input/assets/flags/id.png": "80bb82d11d5bc144a21042e77972bca9",
"assets/packages/intl_phone_number_input/assets/flags/ie.png": "1d91912afc591dd120b47b56ea78cdbf",
"assets/packages/intl_phone_number_input/assets/flags/il.png": "1e06ad7783f24332405d36561024cc4c",
"assets/packages/intl_phone_number_input/assets/flags/im.png": "7c9ccb825f0fca557d795c4330cf4f50",
"assets/packages/intl_phone_number_input/assets/flags/in.png": "1dec13ba525529cffd4c7f8a35d51121",
"assets/packages/intl_phone_number_input/assets/flags/io.png": "83d45bbbff087d47b2b39f1c20598f52",
"assets/packages/intl_phone_number_input/assets/flags/iq.png": "8e9600510ae6ebd2023e46737ca7cd02",
"assets/packages/intl_phone_number_input/assets/flags/ir.png": "37f67c3141e9843196cb94815be7bd37",
"assets/packages/intl_phone_number_input/assets/flags/is.png": "907840430252c431518005b562707831",
"assets/packages/intl_phone_number_input/assets/flags/it.png": "5c8e910e6a33ec63dfcda6e8960dd19c",
"assets/packages/intl_phone_number_input/assets/flags/je.png": "288f8dca26098e83ff0455b08cceca1b",
"assets/packages/intl_phone_number_input/assets/flags/jm.png": "074400103847c56c37425a73f9d23665",
"assets/packages/intl_phone_number_input/assets/flags/jo.png": "c01cb41f74f9db0cf07ba20f0af83011",
"assets/packages/intl_phone_number_input/assets/flags/jp.png": "25ac778acd990bedcfdc02a9b4570045",
"assets/packages/intl_phone_number_input/assets/flags/ke.png": "cf5aae3699d3cacb39db9803edae172b",
"assets/packages/intl_phone_number_input/assets/flags/kg.png": "c4aa6d221d9a9d332155518d6b82dbc7",
"assets/packages/intl_phone_number_input/assets/flags/kh.png": "d48d51e8769a26930da6edfc15de97fe",
"assets/packages/intl_phone_number_input/assets/flags/ki.png": "4d0b59fe3a89cd0c8446167444b07548",
"assets/packages/intl_phone_number_input/assets/flags/km.png": "5554c8746c16d4f482986fb78ffd9b36",
"assets/packages/intl_phone_number_input/assets/flags/kn.png": "f318e2fd87e5fd2cabefe9ff252bba46",
"assets/packages/intl_phone_number_input/assets/flags/kp.png": "e1c8bb52f31fca22d3368d8f492d8f27",
"assets/packages/intl_phone_number_input/assets/flags/kr.png": "79d162e210b8711ae84e6bd7a370cf70",
"assets/packages/intl_phone_number_input/assets/flags/kw.png": "3ca448e219d0df506fb2efd5b91be092",
"assets/packages/intl_phone_number_input/assets/flags/ky.png": "3d1cbb9d896b17517ef6695cf9493d05",
"assets/packages/intl_phone_number_input/assets/flags/kz.png": "cb3b0095281c9d7e7fb5ce1716ef8ee5",
"assets/packages/intl_phone_number_input/assets/flags/la.png": "e8cd9c3ee6e134adcbe3e986e1974e4a",
"assets/packages/intl_phone_number_input/assets/flags/lb.png": "f80cde345f0d9bd0086531808ce5166a",
"assets/packages/intl_phone_number_input/assets/flags/lc.png": "8c1a03a592aa0a99fcaf2b81508a87eb",
"assets/packages/intl_phone_number_input/assets/flags/li.png": "ecdf7b3fe932378b110851674335d9ab",
"assets/packages/intl_phone_number_input/assets/flags/lk.png": "5a3a063cfff4a92fb0ba6158e610e025",
"assets/packages/intl_phone_number_input/assets/flags/lr.png": "b92c75e18dd97349c75d6a43bd17ee94",
"assets/packages/intl_phone_number_input/assets/flags/ls.png": "2bca756f9313957347404557acb532b0",
"assets/packages/intl_phone_number_input/assets/flags/lt.png": "7df2cd6566725685f7feb2051f916a3e",
"assets/packages/intl_phone_number_input/assets/flags/lu.png": "6274fd1cae3c7a425d25e4ccb0941bb8",
"assets/packages/intl_phone_number_input/assets/flags/lv.png": "53105fea0cc9cc554e0ceaabc53a2d5d",
"assets/packages/intl_phone_number_input/assets/flags/ly.png": "8d65057351859065d64b4c118ff9e30e",
"assets/packages/intl_phone_number_input/assets/flags/ma.png": "057ea2e08587f1361b3547556adae0c2",
"assets/packages/intl_phone_number_input/assets/flags/mc.png": "90c2ad7f144d73d4650cbea9dd621275",
"assets/packages/intl_phone_number_input/assets/flags/md.png": "8911d3d821b95b00abbba8771e997eb3",
"assets/packages/intl_phone_number_input/assets/flags/me.png": "590284bc85810635ace30a173e615ca4",
"assets/packages/intl_phone_number_input/assets/flags/mf.png": "134bee9f9d794dc5c0922d1b9bdbb710",
"assets/packages/intl_phone_number_input/assets/flags/mg.png": "0ef6271ad284ebc0069ff0aeb5a3ad1e",
"assets/packages/intl_phone_number_input/assets/flags/mh.png": "18dda388ef5c1cf37cae5e7d5fef39bc",
"assets/packages/intl_phone_number_input/assets/flags/mk.png": "835f2263974de523fa779d29c90595bf",
"assets/packages/intl_phone_number_input/assets/flags/ml.png": "0c50dfd539e87bb4313da0d4556e2d13",
"assets/packages/intl_phone_number_input/assets/flags/mm.png": "32e5293d6029d8294c7dfc3c3835c222",
"assets/packages/intl_phone_number_input/assets/flags/mn.png": "16086e8d89c9067d29fd0f2ea7021a45",
"assets/packages/intl_phone_number_input/assets/flags/mo.png": "849848a26bbfc87024017418ad7a6233",
"assets/packages/intl_phone_number_input/assets/flags/mp.png": "87351c30a529071ee9a4bb67765fea4f",
"assets/packages/intl_phone_number_input/assets/flags/mq.png": "710f4e8f862a155bfda542d747f6d8a6",
"assets/packages/intl_phone_number_input/assets/flags/mr.png": "f2a62602d43a1ee14625af165b96ce2f",
"assets/packages/intl_phone_number_input/assets/flags/ms.png": "ae3dde287cba609de4908f78bc432fc0",
"assets/packages/intl_phone_number_input/assets/flags/mt.png": "f3119401ae0c3a9d6e2dc23803928c06",
"assets/packages/intl_phone_number_input/assets/flags/mu.png": "c5228d1e94501d846b5bf203f038ae49",
"assets/packages/intl_phone_number_input/assets/flags/mv.png": "d9245f74e34d5c054413ace4b86b4f16",
"assets/packages/intl_phone_number_input/assets/flags/mw.png": "ffc1f18eeedc1dfbb1080aa985ce7d05",
"assets/packages/intl_phone_number_input/assets/flags/mx.png": "8697753210ea409435aabfb42391ef85",
"assets/packages/intl_phone_number_input/assets/flags/my.png": "f7f962e8a074387fd568c9d4024e0959",
"assets/packages/intl_phone_number_input/assets/flags/mz.png": "1ab1ac750fbbb453d33e9f25850ac2a0",
"assets/packages/intl_phone_number_input/assets/flags/na.png": "cdc00e9267a873609b0abea944939ff7",
"assets/packages/intl_phone_number_input/assets/flags/nc.png": "cb36e0c945b79d56def11b23c6a9c7e9",
"assets/packages/intl_phone_number_input/assets/flags/ne.png": "a20724c177e86d6a27143aa9c9664a6f",
"assets/packages/intl_phone_number_input/assets/flags/nf.png": "1c2069b299ce3660a2a95ec574dfde25",
"assets/packages/intl_phone_number_input/assets/flags/ng.png": "aedbe364bd1543832e88e64b5817e877",
"assets/packages/intl_phone_number_input/assets/flags/ni.png": "e398dc23e79d9ccd702546cc25f126bf",
"assets/packages/intl_phone_number_input/assets/flags/nl.png": "3649c177693bfee9c2fcc63c191a51f1",
"assets/packages/intl_phone_number_input/assets/flags/no.png": "33bc70259c4908b7b9adeef9436f7a9f",
"assets/packages/intl_phone_number_input/assets/flags/np.png": "6e099fb1e063930bdd00e8df5cef73d4",
"assets/packages/intl_phone_number_input/assets/flags/nr.png": "1316f3a8a419d8be1975912c712535ea",
"assets/packages/intl_phone_number_input/assets/flags/nu.png": "4a10304a6f0b54592985975d4e18709f",
"assets/packages/intl_phone_number_input/assets/flags/nz.png": "7587f27e4fe2b61f054ae40a59d2c9e8",
"assets/packages/intl_phone_number_input/assets/flags/om.png": "cebd9ab4b9ab071b2142e21ae2129efc",
"assets/packages/intl_phone_number_input/assets/flags/pa.png": "78e3e4fd56f0064837098fe3f22fb41b",
"assets/packages/intl_phone_number_input/assets/flags/pe.png": "4d9249aab70a26fadabb14380b3b55d2",
"assets/packages/intl_phone_number_input/assets/flags/pf.png": "1ae72c24380d087cbe2d0cd6c3b58821",
"assets/packages/intl_phone_number_input/assets/flags/pg.png": "0f7e03465a93e0b4e3e1c9d3dd5814a4",
"assets/packages/intl_phone_number_input/assets/flags/ph.png": "e4025d1395a8455f1ba038597a95228c",
"assets/packages/intl_phone_number_input/assets/flags/pk.png": "7a6a621f7062589677b3296ca16c6718",
"assets/packages/intl_phone_number_input/assets/flags/pl.png": "f20e9ef473a9ed24176f5ad74dd0d50a",
"assets/packages/intl_phone_number_input/assets/flags/pm.png": "134bee9f9d794dc5c0922d1b9bdbb710",
"assets/packages/intl_phone_number_input/assets/flags/pn.png": "ab07990e0867813ce13b51085cd94629",
"assets/packages/intl_phone_number_input/assets/flags/pr.png": "d551174a2b132a99c12d21ba6171281d",
"assets/packages/intl_phone_number_input/assets/flags/ps.png": "52a25a48658ca9274830ffa124a8c1db",
"assets/packages/intl_phone_number_input/assets/flags/pt.png": "eba93d33545c78cc67915d9be8323661",
"assets/packages/intl_phone_number_input/assets/flags/pw.png": "2e697cc6907a7b94c7f94f5d9b3bdccc",
"assets/packages/intl_phone_number_input/assets/flags/py.png": "154d4add03b4878caf00bd3249e14f40",
"assets/packages/intl_phone_number_input/assets/flags/qa.png": "bcb7cfa9fa185e00720f901c4a522531",
"assets/packages/intl_phone_number_input/assets/flags/re.png": "134bee9f9d794dc5c0922d1b9bdbb710",
"assets/packages/intl_phone_number_input/assets/flags/ro.png": "85af99741fe20664d9a7112cfd8d9722",
"assets/packages/intl_phone_number_input/assets/flags/rs.png": "9dff535d2d08c504be63062f39eff0b7",
"assets/packages/intl_phone_number_input/assets/flags/ru.png": "6974dcb42ad7eb3add1009ea0c6003e3",
"assets/packages/intl_phone_number_input/assets/flags/rw.png": "d1aae0647a5b1ab977ae43ab894ce2c3",
"assets/packages/intl_phone_number_input/assets/flags/sa.png": "7c95c1a877148e2aa21a213d720ff4fd",
"assets/packages/intl_phone_number_input/assets/flags/sb.png": "296ecedbd8d1c2a6422c3ba8e5cd54bd",
"assets/packages/intl_phone_number_input/assets/flags/sc.png": "e969fd5afb1eb5902675b6bcf49a8c2e",
"assets/packages/intl_phone_number_input/assets/flags/sd.png": "65ce270762dfc87475ea99bd18f79025",
"assets/packages/intl_phone_number_input/assets/flags/se.png": "25dd5434891ac1ca2ad1af59cda70f80",
"assets/packages/intl_phone_number_input/assets/flags/sg.png": "bc772e50b8c79f08f3c2189f5d8ce491",
"assets/packages/intl_phone_number_input/assets/flags/sh.png": "9c0678557394223c4eb8b242770bacd7",
"assets/packages/intl_phone_number_input/assets/flags/si.png": "24237e53b34752554915e71e346bb405",
"assets/packages/intl_phone_number_input/assets/flags/sj.png": "33bc70259c4908b7b9adeef9436f7a9f",
"assets/packages/intl_phone_number_input/assets/flags/sk.png": "2a1ee716d4b41c017ff1dbf3fd3ffc64",
"assets/packages/intl_phone_number_input/assets/flags/sl.png": "61b9d992c8a6a83abc4d432069617811",
"assets/packages/intl_phone_number_input/assets/flags/sm.png": "a8d6801cb7c5360e18f0a2ed146b396d",
"assets/packages/intl_phone_number_input/assets/flags/sn.png": "68eaa89bbc83b3f356e1ba2096b09b3c",
"assets/packages/intl_phone_number_input/assets/flags/so.png": "1ce20d052f9d057250be96f42647513b",
"assets/packages/intl_phone_number_input/assets/flags/sr.png": "9f912879f2829a625436ccd15e643e39",
"assets/packages/intl_phone_number_input/assets/flags/ss.png": "b0120cb000b31bb1a5c801c3592139bc",
"assets/packages/intl_phone_number_input/assets/flags/st.png": "fef62c31713ff1063da2564df3f43eea",
"assets/packages/intl_phone_number_input/assets/flags/sv.png": "38809d2409ae142c87618709e4475b0f",
"assets/packages/intl_phone_number_input/assets/flags/sx.png": "9c19254973d8acf81581ad95b408c7e6",
"assets/packages/intl_phone_number_input/assets/flags/sy.png": "24186a0f4ce804a16c91592db5a16a3a",
"assets/packages/intl_phone_number_input/assets/flags/sz.png": "d1829842e45c2b2b29222c1b7e201591",
"assets/packages/intl_phone_number_input/assets/flags/tc.png": "036010ddcce73f0f3c5fd76cbe57b8fb",
"assets/packages/intl_phone_number_input/assets/flags/td.png": "009303b6188ca0e30bd50074b16f0b16",
"assets/packages/intl_phone_number_input/assets/flags/tf.png": "b2c044b86509e7960b5ba66b094ea285",
"assets/packages/intl_phone_number_input/assets/flags/tg.png": "7f91f02b26b74899ff882868bd611714",
"assets/packages/intl_phone_number_input/assets/flags/th.png": "11ce0c9f8c738fd217ea52b9bc29014b",
"assets/packages/intl_phone_number_input/assets/flags/tj.png": "c73b793f2acd262e71b9236e64c77636",
"assets/packages/intl_phone_number_input/assets/flags/tk.png": "60428ff1cdbae680e5a0b8cde4677dd5",
"assets/packages/intl_phone_number_input/assets/flags/tl.png": "c80876dc80cda5ab6bb8ef078bc6b05d",
"assets/packages/intl_phone_number_input/assets/flags/tm.png": "0980fb40ec450f70896f2c588510f933",
"assets/packages/intl_phone_number_input/assets/flags/tn.png": "6612e9fec4bef022cbd45cbb7c02b2b6",
"assets/packages/intl_phone_number_input/assets/flags/to.png": "1cdd716b5b5502f85d6161dac6ee6c5b",
"assets/packages/intl_phone_number_input/assets/flags/tr.png": "27feab1a5ca390610d07e0c6bd4720d5",
"assets/packages/intl_phone_number_input/assets/flags/tt.png": "a8e1fc5c65dc8bc362a9453fadf9c4b3",
"assets/packages/intl_phone_number_input/assets/flags/tv.png": "04680395c7f89089e8d6241ebb99fb9d",
"assets/packages/intl_phone_number_input/assets/flags/tw.png": "b1101fd5f871a9ffe7c9ad191a7d3304",
"assets/packages/intl_phone_number_input/assets/flags/tz.png": "56ec99c7e0f68b88a2210620d873683a",
"assets/packages/intl_phone_number_input/assets/flags/ua.png": "b4b10d893611470661b079cb30473871",
"assets/packages/intl_phone_number_input/assets/flags/ug.png": "9a0f358b1eb19863e21ae2063fab51c0",
"assets/packages/intl_phone_number_input/assets/flags/um.png": "8fe7c4fed0a065fdfb9bd3125c6ecaa1",
"assets/packages/intl_phone_number_input/assets/flags/us.png": "83b065848d14d33c0d10a13e01862f34",
"assets/packages/intl_phone_number_input/assets/flags/uy.png": "da4247b21fcbd9e30dc2b3f7c5dccb64",
"assets/packages/intl_phone_number_input/assets/flags/uz.png": "3adad3bac322220cac8abc1c7cbaacac",
"assets/packages/intl_phone_number_input/assets/flags/va.png": "c010bf145f695d5c8fb551bafc081f77",
"assets/packages/intl_phone_number_input/assets/flags/vc.png": "da3ca14a978717467abbcdece05d3544",
"assets/packages/intl_phone_number_input/assets/flags/ve.png": "893391d65cbd10ca787a73578c77d3a7",
"assets/packages/intl_phone_number_input/assets/flags/vg.png": "6855eed44c0ed01b9f8fe28a20499a6d",
"assets/packages/intl_phone_number_input/assets/flags/vi.png": "3f317c56f31971b3179abd4e03847036",
"assets/packages/intl_phone_number_input/assets/flags/vn.png": "32ff65ccbf31a707a195be2a5141a89b",
"assets/packages/intl_phone_number_input/assets/flags/vu.png": "3f201fdfb6d669a64c35c20a801016d1",
"assets/packages/intl_phone_number_input/assets/flags/wf.png": "6f1644b8f907d197c0ff7ed2f366ad64",
"assets/packages/intl_phone_number_input/assets/flags/ws.png": "f206322f3e22f175869869dbfadb6ce8",
"assets/packages/intl_phone_number_input/assets/flags/xk.png": "980a56703da8f6162bd5be7125be7036",
"assets/packages/intl_phone_number_input/assets/flags/ye.png": "4cf73209d90e9f02ead1565c8fdf59e5",
"assets/packages/intl_phone_number_input/assets/flags/yt.png": "134bee9f9d794dc5c0922d1b9bdbb710",
"assets/packages/intl_phone_number_input/assets/flags/za.png": "7687ddd4961ec6b32f5f518887422e54",
"assets/packages/intl_phone_number_input/assets/flags/zm.png": "81cec35b715f227328cad8f314acd797",
"assets/packages/intl_phone_number_input/assets/flags/zw.png": "078a3267ea8eabf88b2d43fe4aed5ce5",
"assets/packages/libphonenumber_plugin/assets/js/libphonenumber.js": "88b22ae35b39feec4fae0bf38bb37813",
"assets/packages/libphonenumber_plugin/assets/js/stringbuffer.js": "6841824b0e11a399b78d135a7bfb5c53",
"assets/packages/libphonenumber_plugin/js/libphonenumber.js": "88b22ae35b39feec4fae0bf38bb37813",
"assets/packages/libphonenumber_plugin/js/stringbuffer.js": "6841824b0e11a399b78d135a7bfb5c53",
"assets/packages/media_kit/assets/web/hls1.4.10.js": "1e36f4683b03af6692ad2542810f28bc",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/sign_in_button/assets/logos/2.0x/facebook_new.png": "dd8e500c6d946b0f7c24eb8b94b1ea8c",
"assets/packages/sign_in_button/assets/logos/2.0x/google_dark.png": "68d675bc88e8b2a9079fdfb632a974aa",
"assets/packages/sign_in_button/assets/logos/2.0x/google_light.png": "1f00e2bbc0c16b9e956bafeddebe7bf2",
"assets/packages/sign_in_button/assets/logos/3.0x/facebook_new.png": "689ce8e0056bb542425547325ce690ba",
"assets/packages/sign_in_button/assets/logos/3.0x/google_dark.png": "c75b35db06cb33eb7c52af696026d299",
"assets/packages/sign_in_button/assets/logos/3.0x/google_light.png": "3aeb09c8261211cfc16ac080a555c43c",
"assets/packages/sign_in_button/assets/logos/facebook_new.png": "93cb650d10a738a579b093556d4341be",
"assets/packages/sign_in_button/assets/logos/google_dark.png": "d18b748c2edbc5c4e3bc221a1ec64438",
"assets/packages/sign_in_button/assets/logos/google_light.png": "f71e2d0b0a2bc7d1d8ab757194a02cac",
"assets/packages/tdesign_flutter/assets/tdesign/TCloudNumberVF.ttf": "4f66f7ac7b3b222eb82f69539c49662c",
"assets/packages/tdesign_flutter/assets/tdesign/td_icons.ttf": "d6f2512cd2d241c66172961cf738ca8b",
"assets/packages/tencent_calls_uikit/assets/audios/phone_dialing.mp3": "a3fc546bc9fd7d3053a9933fe0e30daf",
"assets/packages/tencent_calls_uikit/assets/audios/phone_hangup.mp3": "33490500b8169668f5074bb8cb2547a1",
"assets/packages/tencent_calls_uikit/assets/audios/phone_ringing.mp3": "baff2a79b59f40e66459ad9eeefb59f1",
"assets/packages/tencent_calls_uikit/assets/images/add_user.png": "6399e534e247f0d895a87e91363b7403",
"assets/packages/tencent_calls_uikit/assets/images/arrow.png": "7d7d20720b1b2f5e0b4e17e051bf39c8",
"assets/packages/tencent_calls_uikit/assets/images/audio_unavailable.png": "7e7cc8cb37653b04efc36fbd1a848bcf",
"assets/packages/tencent_calls_uikit/assets/images/audio_unavailable_grey.png": "d70c279dc70fab3dd2c702748ad9d5d1",
"assets/packages/tencent_calls_uikit/assets/images/blur_background_accept.png": "31ecd85968337e6d61c023c013402146",
"assets/packages/tencent_calls_uikit/assets/images/blur_background_waiting_disable.png": "dead9ae533d46a55c212f70f6d7f65f1",
"assets/packages/tencent_calls_uikit/assets/images/blur_background_waiting_enable.png": "e43613472fd314813956fda352d3f3ec",
"assets/packages/tencent_calls_uikit/assets/images/camera_off.png": "36990b162868f5a9dac47cd7ab8108cd",
"assets/packages/tencent_calls_uikit/assets/images/camera_on.png": "caf4d0fa5f5ebb2c9fc998ee03ea636d",
"assets/packages/tencent_calls_uikit/assets/images/check_box_group_selected.png": "79316096f767602ddb7ac68c018a687d",
"assets/packages/tencent_calls_uikit/assets/images/check_box_group_unselected.png": "bb4fc328e70273945feb37713816fda5",
"assets/packages/tencent_calls_uikit/assets/images/dialing.png": "ed23abfde97d28036502095c071264e6",
"assets/packages/tencent_calls_uikit/assets/images/floating_button.png": "9b81c3741ca4c1dad47864b58c2cc72c",
"assets/packages/tencent_calls_uikit/assets/images/handsfree.png": "577d6fe7390f9d26d36e31fb01070145",
"assets/packages/tencent_calls_uikit/assets/images/handsfree_on.png": "b55e9b0ddbe7c607f6b725154e8f927e",
"assets/packages/tencent_calls_uikit/assets/images/hangup.png": "e2ca6c0b7a35174efde6e3ec7eaf1609",
"assets/packages/tencent_calls_uikit/assets/images/join_group_call.png": "bb2459d3663e870b697a3c40096f86a5",
"assets/packages/tencent_calls_uikit/assets/images/join_group_compress.png": "a36ff6076967c72cfc7bafb40c2e44d8",
"assets/packages/tencent_calls_uikit/assets/images/join_group_expand.png": "44b028813d7da2597f24eac4ad46e72d",
"assets/packages/tencent_calls_uikit/assets/images/loading.gif": "9d0e89898974f657af212ed26eeebb34",
"assets/packages/tencent_calls_uikit/assets/images/mute.png": "ea4f5db8c4872e65f5a6aa69a8d72316",
"assets/packages/tencent_calls_uikit/assets/images/mute_on.png": "79a93858c66ca0d1d6bad3c85706e261",
"assets/packages/tencent_calls_uikit/assets/images/speaking.png": "fe2fbcb3497786015a580c723d3a6241",
"assets/packages/tencent_calls_uikit/assets/images/switch_camera.png": "f681ce8fdc32689ef5a491a80c8eeefc",
"assets/packages/tencent_calls_uikit/assets/images/switch_camera_group.png": "d4a16408abd38d2f1320753548a49ee2",
"assets/packages/tencent_calls_uikit/assets/images/user_icon.png": "23f8841079dceeb9ae7babc308d704bd",
"assets/packages/tencent_calls_uikit/assets/images/virtual_background.png": "6bfd8bf190926c17649d606fe20dc723",
"assets/packages/tencent_cloud_chat_common/images/excel.png": "16626eefe0c09df1174cb8c2937dcd79",
"assets/packages/tencent_cloud_chat_common/images/image_icon.png": "479597d2b7fc098012aaaee4386c1ce4",
"assets/packages/tencent_cloud_chat_common/images/pdf.png": "1f2b2034154798a0b98ea803ed9f0d3e",
"assets/packages/tencent_cloud_chat_common/images/ppt.png": "d0c0735d537acf24ba9f357057f9c50e",
"assets/packages/tencent_cloud_chat_common/images/txt.png": "6e518e12822ab7c0dccc943025fb83d1",
"assets/packages/tencent_cloud_chat_common/images/unknown.png": "5e71d355dd39cf8de0dcc70458c6b5c2",
"assets/packages/tencent_cloud_chat_common/images/video_icon.png": "5bcb4e052dc236951ee020714f78ef1f",
"assets/packages/tencent_cloud_chat_common/images/word.png": "32c792cab3b4fc31f7228659678463da",
"assets/packages/tencent_cloud_chat_common/images/zip.png": "fbbd00fc6fefe17631406db86418145a",
"assets/packages/tencent_cloud_chat_message/lib/assets/copy_message.svg": "65e2664fdd2877bd0f07be7a0a0a9c91",
"assets/packages/tencent_cloud_chat_message/lib/assets/delete.png": "aec05999099c486a39eeb069323c759c",
"assets/packages/tencent_cloud_chat_message/lib/assets/delete_message.svg": "805d006b04025a680965c194ab987fb6",
"assets/packages/tencent_cloud_chat_message/lib/assets/forward_message.svg": "1f4fbb7243936e2ed756ffcc72f7c546",
"assets/packages/tencent_cloud_chat_message/lib/assets/message_history.svg": "4d0fd86f8a3b9534c092cc66157ed908",
"assets/packages/tencent_cloud_chat_message/lib/assets/multi_message.svg": "39c39bc8282542b8c884e640a4f9c361",
"assets/packages/tencent_cloud_chat_message/lib/assets/open_in_new.png": "d649c1143dfeae30a5075078984057a5",
"assets/packages/tencent_cloud_chat_message/lib/assets/reply_message.svg": "cbae5a4f7d40d820503e1e737cfedb84",
"assets/packages/tencent_cloud_chat_message/lib/assets/revoke_message.svg": "00141f89def3f6a57302d2485990e43b",
"assets/packages/tencent_cloud_chat_message/lib/assets/send_code.svg": "620161a726f14a92cd39ca42dc60b798",
"assets/packages/tencent_cloud_chat_message/lib/assets/send_face.png": "ba683da189a3e5a35934c4728fb1bc09",
"assets/packages/tencent_cloud_chat_message/lib/assets/send_face.svg": "3ddb433551480d23e53e3a0dd1d7481e",
"assets/packages/tencent_cloud_chat_message/lib/assets/send_file.svg": "b1fe84dd45f89b8fb51f48e5104b3c76",
"assets/packages/tencent_cloud_chat_message/lib/assets/send_image.svg": "715e72f4a511d466677e133f42000c61",
"assets/packages/tencent_cloud_chat_message/lib/assets/send_screenshot.svg": "3cb7c676393739ce082fba2efa493d96",
"assets/packages/tencent_cloud_chat_message/lib/assets/send_video.svg": "db85d3b0dd35b85080101ac5709b80c5",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz00@2x.png": "2b6c0bfaaaa6a8b176ccf1bb6251d5b5",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz01@2x.png": "0eeccf75ef05e3691a9471e7d3feec39",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz02@2x.png": "e9300a2d54b674570d545b478a597bb9",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz03@2x.png": "cdf3583dd507684e66cc5385c0a346c1",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz04@2x.png": "2fb76abc2bb9576accfbe7d9bc4fcb91",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz05@2x.png": "de87a11f6103576470da01ea40c5cdc8",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz06@2x.png": "0ac5a54ce1528fb15a8eb12dd9fcbffb",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz07@2x.png": "24268381e6c718c3c5ab3a674308a3c6",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz08@2x.png": "adced74d2d4285cfa8d78862e1d9a605",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz09@2x.png": "db342a9011e1815dd9bc7de54473f5e6",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz10@2x.png": "9513d94e7533551e6a136340e845dd7a",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz11@2x.png": "f569124c2a7fe0c5aff73acb50558226",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz12@2x.png": "7a6d1fae173fea4f510ccc79fb810b24",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz13@2x.png": "95d857794573ec3a7d42c27c4b364d4d",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz14@2x.png": "10b43ce46c8ca6fe5ee5e4c31a932bb1",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz15@2x.png": "46ec5f97ee6302cfadcc1c67114d43a8",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz16@2x.png": "de9c169b055541f0a9b8100fa1cd93a1",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4350/yz17@2x.png": "2739c6820f6fd1704adc4e98e1fb4d8b",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys00@2x.png": "a9d5287897d593bde802ee96c2c7522f",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys01@2x.png": "1fb7be3bfdff928d81730e1e030f8711",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys02@2x.png": "d0fcdbf427e442af607031be0da7dddd",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys03@2x.png": "18d2142c1237bdd2a6189d83b962fd7f",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys04@2x.png": "b40044d96ac4ac7806d4ae3fa6e7550c",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys05@2x.png": "453fa78ca2d4267495eec5d06cd3205b",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys06@2x.png": "44fffdf7a4f42163a780780fe5a8a667",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys07@2x.png": "48706f79e1fc5155e8488d5b4555ca3f",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys08@2x.png": "8ba9a9801bc5128dd2affeb82800e1de",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys09@2x.png": "0230788af301e99de8fc0821ec45dd0c",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys10@2x.png": "9db088e6918729908680f7ef0fca63a4",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys11@2x.png": "9b752ab254c4091220116c77a931c307",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys12@2x.png": "53792f6d9ac954c50859dae954576ffa",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys13@2x.png": "af5e5133259331025047338c1df305d9",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys14@2x.png": "b5c5cfcbf7d9f8fe640085eb5d33dda3",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4351/ys15@2x.png": "c6ed953441649e617978c0954f503941",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs00@2x.png": "2c9b80ed5c6a76d503609cc21214754c",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs01@2x.png": "0f3d1d2fd1bdace295dcf9c68f0826a2",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs02@2x.png": "f8686062f1974925c3efcdb57e134e37",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs03@2x.png": "7c9740b8c9ac8f978cbb255eb93f2969",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs04@2x.png": "0933b59d6f97f6b2f70bbc05c2c46b47",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs05@2x.png": "c2e81e2470cd4d498608c9dbf577c9e1",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs06@2x.png": "eaff5b922e07925922bdfaefc28e781f",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs07@2x.png": "c6120c08136ceb77be2d6c0e3babb45d",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs08@2x.png": "1e0b9ab84afa11a1e6afae39a282c73f",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs09@2x.png": "7fcda31d610e3ca69dcd12295a84fc46",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs10@2x.png": "3892a7dc7d8d2d7786b079c8800d5614",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs11@2x.png": "cd6ece84db447b21e43b2c407fa2ab1f",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs12@2x.png": "3768acab74871fa8e9c154843844c540",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs13@2x.png": "7451dc7333a0d60b4d240d33a977ecea",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs14@2x.png": "160783ffe708e9c0bc898bb5c74071da",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs15@2x.png": "1392e8304c4851c2473126aa6be900d9",
"assets/packages/tencent_cloud_chat_sticker/assets/custom_face_resource/4352/gcs16@2x.png": "9dea32f3d207c6c7d5ced29075d9e621",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_0.png": "541ea3c008c65b7a636d61b0dc54fbc2",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_1.png": "62b63a08ff275506026873026036aee8",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_10.png": "c1e5928a19e7d1ff4ae2b2a6940cd004",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_11.png": "75f0006078d276c9ce6e41654579d2eb",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_12.png": "9bd567e65894ec6bdf1c119b4a7daf23",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_13.png": "b5f6fb27f47d2a571db541b03e21ef4c",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_14.png": "fee2411db7add2a4c0d3c990c0beac36",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_15.png": "649ec58dd96847bf5ef3285e15c9d6e7",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_16.png": "75da58ee1fc2fcaea0b68f50c2ab928f",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_17.png": "f51c1d73d41f4e1b73f914ee6198202c",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_18.png": "39fdefbd75316a92559905b4a776e7e6",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_19.png": "05e8d2c3b2f25ce5a0e23f6683651764",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_2.png": "3e9c9e9da9f0e664c9227c73cfdb969a",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_20.png": "bd0ba10dfa9bac7a41c86e9424496f13",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_21.png": "db8f12318b488b7ab99eb427112381e4",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_22.png": "b65952d037699f6122e949fc61f11a02",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_23.png": "e16444b274e87068311500c770f1b403",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_24.png": "73636ed666b3e3eb8ab4768f5dfb7303",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_25.png": "5dc3114e94952b1d140e9331acad7e15",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_26.png": "31a38caf38e6f18c20edace14fb33ce5",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_27.png": "89e1f5c590d3d4d3dc4dddbcab27f85e",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_28.png": "5e190ec6b30a4dee2ea73263a2d58702",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_29.png": "64a20230639fb90ee4f38578eb061dda",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_3.png": "42949c1c249dc9b3c2160fcebb843aa6",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_30.png": "ee83fa3a246ab94dcec1414481d48911",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_31.png": "024d28ca0dd3898f1fbca673a0717ca3",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_32.png": "f7f09cb422b504c60a71fa4f2577c158",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_33.png": "c30358df1d58813426ea6595c20243f0",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_34.png": "6069cd71a9b54ba678a62b8832580f1c",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_35.png": "ce552b1a4d4cf252562844b75b792797",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_36.png": "59ff2f3bf522585b54a9c9c89739e61c",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_37.png": "d230398225c86068605e1967fa68404b",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_38.png": "55d318b6e435a704adfc9db294c58017",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_39.png": "06b4ba2af687eb004ee2b477bd92aaa5",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_4.png": "129d0901afb290fb0c1a3b23f0bb7967",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_40.png": "37e47a7af320b527ff0d3b427d11d5a0",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_41.png": "71d8d68886644e301c280b6b56313407",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_42.png": "db1bbb793898d5c3e7fb294343d6dc80",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_43.png": "e694ad6f4facf65dc3c19e18c4193836",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_44.png": "f57dfdca466456a3b2e8b2478b27d6fa",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_45.png": "07de5fd278902b8d245049bacaf7efed",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_46.png": "31594229c559496eb2dcc76b2941d2da",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_47.png": "207bb16c6c6762ce27d09c9d298198a8",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_48.png": "0510f333a408a37274433ec703d17ba0",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_49.png": "4fcebba0c007effb6b7dbc1d31b21cba",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_5.png": "63b3039c2e0766c30abbe7addaa32d70",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_50.png": "e44d66f3c8f016775dc6871c4378a10b",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_51.png": "58a1ae299a523049a87c8cd7cdf74990",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_52.png": "5c6f9357e57a96d2ea70cc15f9238a86",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_53.png": "c965ee0cf4b8e11e2c764f4e4468a1b2",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_54.png": "ca6f339b9106e6a75754ec5702ec39b2",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_55.png": "dd07ba5675cf8cb0999089b065270c32",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_56.png": "73bc3822362cc56436474553234c14fe",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_57.png": "fc8c9701b4a71dd1e331db5c1ca5b293",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_58.png": "89d665b0917d44c9bc83e8a63c0b6735",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_59.png": "2852d5159a555b5de78348f12c1537c6",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_6.png": "f668c01d5df5bb6f2ce1e14e69213027",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_60.png": "42326a9a8b8dd6819d922547f923666a",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_61.png": "8b5121b03411a6c452634b92a7a1a5a3",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_7.png": "f8ead9f19a2de9b95269aa0c84e9636d",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_8.png": "3fe0b69cf7a18c6824b799b216848504",
"assets/packages/tencent_cloud_chat_sticker/assets/stickers/emoji_9.png": "21c70343179aff53869279458822a815",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_add_option_disable.png": "d85f747ea6e9e9f42b99d0e1daa79d23",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_add_option_enable.png": "ce3b28df5b097bef784096c13c400208",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_add_option_enable_light.png": "689a67279ef35a9c4cc5ceaecfe36fe1",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_add_option_enable_lively.png": "0e927ae509035cc70fb28c0a46d592f8",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_add_option_enable_pressed.png": "64865626b6d0b2a04280e40b2d580e9f",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_add_option_enable_pressed_light.png": "64865626b6d0b2a04280e40b2d580e9f",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_add_option_enable_pressed_lively.png": "64865626b6d0b2a04280e40b2d580e9f",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_add_option_enable_pressed_serious.png": "64865626b6d0b2a04280e40b2d580e9f",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_add_option_enable_serious.png": "ce3b28df5b097bef784096c13c400208",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_delete_option_disable.png": "6c95edc8722a5b4d930aede7d0243b5d",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_delete_option_enable.png": "a01b437939711fa4d9f9fc3f9910d21f",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_delete_option_enable_lively.png": "dd6b09d07055ee67c26d2bbad9d4e930",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_delete_option_enable_pressed.png": "8a1aeec54e9277df681e4cc8a92ef030",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_message_title_icon.png": "9f6fd66039ddf7a016504af612965ef7",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_message_title_icon_light.png": "9f6fd66039ddf7a016504af612965ef7",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_message_title_icon_lively.png": "15e0cb443b12c92caadf10ea5df86b23",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_message_title_icon_serious.png": "9f6fd66039ddf7a016504af612965ef7",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_multi_selected_icon_light.png": "eee02f0ce6e6b09a20a2636026f3f978",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_multi_selected_icon_lively.png": "e44b1eaa3c529db150242a39cab579e2",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_multi_selected_icon_serious.png": "eee02f0ce6e6b09a20a2636026f3f978",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_multi_unselected_icon.png": "37f828e5964866addbf89f4d19bf2189",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_selected_icon.png": "5355c65d2439d6151352a80d012a0ee6",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_single_selected_icon_light.png": "5355c65d2439d6151352a80d012a0ee6",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_single_selected_icon_lively.png": "7d549739168317b9ae991ef746500317",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_single_selected_icon_serious.png": "5355c65d2439d6151352a80d012a0ee6",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_single_unselected_icon.png": "725bb149a3405b85a7dd96deb34eea83",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/poll_option_unselected_icon.png": "725bb149a3405b85a7dd96deb34eea83",
"assets/packages/tencent_cloud_chat_vote_plugin/assets/tui_poll_ic.png": "ba40d9b6b988dca21b6f8b88ee4e02fc",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.ico": "6dc7d18e9ddae4c26dbffb428ecf2351",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "763828b916704bba07a1b90343d267be",
"icons/128.png": "4a644a7f3f6023c54cf98f9b7e6d8573",
"icons/48.png": "f21d81a501cc2ef2588edda03905712d",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "238d99690d79543620ebf03604fb12f1",
"/": "238d99690d79543620ebf03604fb12f1",
"main.dart.js": "eb681e9d2a81d34b3f3f6ca13bc230b4",
"manifest.json": "fcf124ad95f8d99f5dfe03ebba461c0a",
"node_modules/@tencentcloud/chat/index.d.ts": "6dd3c99e9a04b5e855f64759ac1a659c",
"node_modules/@tencentcloud/chat/index.es.js": "3cb628d0476da27d466ecb973810e568",
"node_modules/@tencentcloud/chat/index.js": "9992dcd269b6bb17ce5717de3d4a61e1",
"node_modules/@tencentcloud/chat/modules/follow-module.js": "740d78314faaa669277b03213633b79c",
"node_modules/@tencentcloud/chat/modules/group-module.js": "7598ad2ab1b02c9f5e9374e7c0d74436",
"node_modules/@tencentcloud/chat/modules/relationship-module.js": "8ddede57b54256f3baeaeab4c125c42c",
"node_modules/@tencentcloud/chat/modules/signaling-module.js": "f2fb0d22fa5902b8e1c927b36db8bb9e",
"node_modules/@tencentcloud/chat/package.json": "0b6fe3f87fb6c8de786e3a0f28b162ad",
"node_modules/@tencentcloud/chat/README.md": "28ba90c3e189092a4fce6137e99b6918",
"node_modules/tim-upload-plugin/index.d.ts": "4fa5ef8d7c6a6c3ee3d6cc74d161cd72",
"node_modules/tim-upload-plugin/index.js": "bc690d6aa927363856739b28ea8f740a",
"node_modules/tim-upload-plugin/package.json": "e6a67f1faf61bc3336b105908d0a4b69",
"node_modules/tim-upload-plugin/README.md": "6ccd3332f2fb48211bbb002fad6bdcdf",
"package-lock.json": "d41f67280f6ebf4f3abf2a08348b7779",
"package.json": "8b0fc34a2c311512094d69c846087d3d",
"splash/img/light-background.png": "0fe529228f80b67333916091b6fd45ee",
"version.json": "d5f724e72d4a93175d0df3e41f679906"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
