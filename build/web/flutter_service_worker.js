'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "85ca58f8f62039ede95883c033e51c7f",
"index.html": "ff194a76409c6eb01ae8a5e97abbc766",
"/": "ff194a76409c6eb01ae8a5e97abbc766",
"main.dart.js": "b42fe7605260a5a1d89ffe9cb7554a20",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "30181988f5d2fb0375e1de869ce66b3c",
"assets/AssetManifest.json": "0c0e3f5f3b330dd54e6796e71f238042",
"assets/NOTICES": "ef27c1d938b58f5a3dc5f38166beed92",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "ffed6899ceb84c60a1efa51c809a57e4",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "eaed33dc9678381a55cb5c13edaf241d",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "3241d1d9c15448a4da96df05f3292ffe",
"assets/packages/rflutter_alert/assets/images/icon_success.png": "8bb472ce3c765f567aa3f28915c1a8f4",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_success.png": "7d6abdd1b85e78df76b2837996749a43",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_error.png": "2da9704815c606109493d8af19999a65",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_warning.png": "e4606e6910d7c48132912eb818e3a55f",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_info.png": "612ea65413e042e3df408a8548cefe71",
"assets/packages/rflutter_alert/assets/images/2.0x/close.png": "abaa692ee4fa94f76ad099a7a437bd4f",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_success.png": "1c04416085cc343b99d1544a723c7e62",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_error.png": "15ca57e31f94cadd75d8e2b2098239bd",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_warning.png": "e5f369189faa13e7586459afbe4ffab9",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_info.png": "e68e8527c1eb78949351a6582469fe55",
"assets/packages/rflutter_alert/assets/images/3.0x/close.png": "98d2de9ca72dc92b1c9a2835a7464a8c",
"assets/packages/rflutter_alert/assets/images/icon_error.png": "f2b71a724964b51ac26239413e73f787",
"assets/packages/rflutter_alert/assets/images/icon_warning.png": "ccfc1396d29de3ac730da38a8ab20098",
"assets/packages/rflutter_alert/assets/images/icon_info.png": "3f71f68cae4d420cecbf996f37b0763c",
"assets/packages/rflutter_alert/assets/images/close.png": "13c168d8841fcaba94ee91e8adc3617f",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/assets/hotel/hotel_booking.png": "89f1fbbdc7d80e4a6292622d7f929690",
"assets/assets/hotel/hotel_1.png": "a9ae40f2bd59b4e56bc3d6ddd98768a5",
"assets/assets/hotel/hotel_2.png": "1303973de1c8e2226a34b770aaa50fb0",
"assets/assets/hotel/hotel_3.png": "2f6ae1319a610cea2b8bb86c6c789e9b",
"assets/assets/hotel/hotel_4.png": "d5a6dfd83f984b2b8d5e408e74018412",
"assets/assets/hotel/hotel_5.png": "ee2a764f889388f9e60a981028fe1e91",
"assets/assets/images/userImage.png": "afc26cb27789a846c7047e57cb9c6422",
"assets/assets/images/feedbackImage.png": "5f8e9064f54cf51a70fee2da78a5b014",
"assets/assets/images/inviteImage.png": "4d337cf829c67258aa3aae385f5ec31c",
"assets/assets/images/supportIcon.png": "2eb21b9823a538c996ec667e17388322",
"assets/assets/images/helpImage.png": "2bff0fc93675d32f89db50f2d3e2a5b1",
"assets/assets/fitness_app/fitness_app.png": "bd55b7dc68210a0a5e6fa9341a47dbaf",
"assets/assets/fitness_app/bell.png": "929723572aa737a354244ca14fe5659b",
"assets/assets/fitness_app/communicate.png": "74a1c852468e2f6d593b68946d0321d9",
"assets/assets/fitness_app/tab_4s.png": "40c45bbb7601c039da61be3e3c0f7520",
"assets/assets/fitness_app/settings.png": "a19a2f18e135e91275fd62ae7f701c15",
"assets/assets/fitness_app/lion.png": "915bed4c98dbd8b2e69cb33ca1be804c",
"assets/assets/fitness_app/speaking.png": "4c7ac156f880a21ea37ea4c3d80e9f76",
"assets/assets/fitness_app/tab_3s.png": "a9093dcadf7724797ee22a5a802da7ad",
"assets/assets/fitness_app/tab_1.png": "65561a09f27d6d63d9b08f5ad838d7c4",
"assets/assets/fitness_app/tab_3.png": "2a8f733675e2d8a7c6e9ac67a535bbf2",
"assets/assets/fitness_app/tab_2.png": "517b19a685f9d720062aa9b6100f6181",
"assets/assets/fitness_app/burned.png": "2ffad4b8dff525e57473142f0265b6bd",
"assets/assets/fitness_app/area1.png": "9cbfec64c29ec6821547f1c5093f38b7",
"assets/assets/fitness_app/bottle.png": "840d3c89291f9d3b0a859d7479c10d0c",
"assets/assets/fitness_app/area3.png": "e85a8d2207edfb0325369d93982fba03",
"assets/assets/fitness_app/area2.png": "2863c486c15808e8f105ccac2febfdbc",
"assets/assets/fitness_app/teamwork.png": "db2b4fab03370aa63b56e74df90c2bab",
"assets/assets/fitness_app/dinner.png": "d61779f47b560d09b0df15b346323ac4",
"assets/assets/fitness_app/tab_4.png": "f679006d5a49884f9ae89628d1d62d88",
"assets/assets/fitness_app/tab_2s.png": "7d73917cab1caf7fbcc13f2e801c55d3",
"assets/assets/fitness_app/tab_1s.png": "2781eb4a0d6d7405e3c76a6e76d1290b",
"assets/assets/fitness_app/snack.png": "14a3e91c7a517b0a2f71dbcd86d2104d",
"assets/assets/fitness_app/lunch.png": "6855159f38835c1f03289b102a2e8b52",
"assets/assets/fitness_app/glass.png": "266bca612c726abd6e481a4d890cef8e",
"assets/assets/fitness_app/blend-tool.png": "fd9990797a950890016f501666b19529",
"assets/assets/fitness_app/breakfast.png": "1d2b0e6a7e46a44723131c663471f811",
"assets/assets/fitness_app/coming_soon.png": "ca427043c88f7a5fe12df8c07c1cf1b8",
"assets/assets/fitness_app/eaten.png": "3f7d6f5aea8996d15d52c4c2268abd45",
"assets/assets/fitness_app/back.png": "3836b545f32c4592eb5af2367f076089",
"assets/assets/fitness_app/runner.png": "efb26bd46e91d305bda3b4b3c5a57c54",
"assets/assets/introduction_animation/introduction_image.png": "307c773d181ceeb899559add51c7acb4",
"assets/assets/introduction_animation/introduction_animation.png": "309f80cbbe9ba84d2d643677c7853907",
"assets/assets/introduction_animation/mood_dairy_image.png": "64172e2be2e435a8a002ee49d83d779b",
"assets/assets/introduction_animation/care_image.png": "9bf0ea738c1dcabf5650abea1c02e993",
"assets/assets/introduction_animation/relax_image.png": "750458c224fc63ede91b894cb893fb03",
"assets/assets/introduction_animation/welcome.png": "0b5447c747d72f631c7b92e12f26e2a1",
"assets/assets/design_course/userImage.png": "f0f0f1fe2d13630b6eab4fc122df0879",
"assets/assets/design_course/design_course.png": "056917dfdf670a55361f3fde8efbfd8e",
"assets/assets/design_course/interFace1.png": "cd8a44e8d0af949a031c0ea83958d623",
"assets/assets/design_course/interFace3.png": "25e4c23657b1dac674e352d274ad8b2e",
"assets/assets/design_course/interFace2.png": "c101d35e907f00f40900fca7f9c4c69e",
"assets/assets/design_course/webInterFace.png": "3ac7805ba2cca78a43bcb0658b1098cd",
"assets/assets/design_course/interFace4.png": "aeaa1e1b0de05128ab97337e9a73c25c"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
