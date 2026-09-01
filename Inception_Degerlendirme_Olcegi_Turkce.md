# Inception Projesi Değerlendirme Ölçeği

Bu ekipte **1 öğrenciyi** değerlendirmeniz gerekmektedir.

---

## Giriş

Lütfen aşağıdaki kurallara uyun:

- Değerlendirme süreci boyunca kibar, nazik, saygılı ve yapıcı olun. Topluluğun refahı buna bağlıdır.
- Değerlendirilen öğrenci veya grubun projesindeki olası hataları belirleyin. Tespit edilen sorunları tartışmak ve değerlendirmek için zaman ayırın.
- Akranlarınızın projenin talimatlarını ve işlevsellik kapsamını farklı yorumlamış olabileceğini göz önünde bulundurun. Her zaman açık fikirli olun ve mümkün olduğunca dürüst bir şekilde not verin. Pedagoji, ancak akran değerlendirmesi ciddiye alındığında işe yarar.

---

## Yönergeler

- Yalnızca değerlendirilen öğrenci veya grubun Git repository'sinde teslim edilen çalışmayı not verin.
- Git repository'sinin ilgili öğrenciye/öğrencilere ait olduğunu çift kontrol edin. Projenin beklenen proje olduğundan emin olun. Ayrıca `git clone`'un boş bir dizinde kullanıldığını kontrol edin.
- Sizi resmi repository'nin içeriği olmayan bir şeyi değerlendirmeye yönlendirmek amacıyla kötü niyetli takma ad (alias) kullanılmadığını dikkatlice kontrol edin.
- Sürprizlerden kaçınmak için ve uygunsa, notlamayı kolaylaştırmak amacıyla kullanılan script'leri (test veya otomasyon script'leri gibi) birlikte gözden geçirin.
- Değerlendireceğiniz ödevi tamamlamadıysanız, değerlendirme sürecine başlamadan önce tüm konuyu okumalısınız.
- Boş repository, çalışmayan program, Norm hatası, kopya vb. durumları bildirmek için mevcut flag'leri kullanın. Bu durumlarda değerlendirme süreci sona erer ve nihai not 0 olur; kopya durumunda ise -42 olur. Ancak kopya dışındaki durumlarda, öğrencilerin gelecekte tekrarlanmaması gereken hataları tespit etmek için teslim edilen çalışmayı birlikte gözden geçirmeleri şiddetle tavsiye edilir.

---

## Ön koşullar

Kopya şüphesi varsa, değerlendirme burada durur. Bunu bildirmek için "Cheat" flag'ini kullanın. Bu butonu temkinli ve bilinçli kullanın; lütfen bu butona basmadan önce iki kez düşünün.

### Ön testler

- Örneğin, bilgileri saklamak için yerel bir `.env` dosyası kullanılması ve/veya Docker secrets kullanılması serbesttir. Ancak Git repository'sinde herhangi bir kimlik bilgisi (credential), API key veya parola mevcutsa ve bunlar secrets kapsamı dışındaysa, değerlendirme durur ve not 0 olur.
- Savunma, yalnızca değerlendirilen öğrenci veya grup hazır olduğunda gerçekleşebilir. Böylece herkes bilgisini birbirleriyle paylaşabilir.
- Hiçbir çalışma teslim edilmemişse (ya da yanlış dosyalar, yanlış dizin veya yanlış dosya adları varsa), değerlendirme süreci sona erer.
- Bu proje için Git repository'sini onların makinesine clone'lamanız gerekmektedir.

---

## Genel talimatlar

Değerlendirme süreci boyunca, bir gereksinimi nasıl kontrol edeceğinizi veya doğrulayacağınızı bilmiyorsanız, değerlendirilen öğrencinin size yardımcı olması gerekmektedir.

Uygulamayı yapılandırmak için gerekli tüm dosyaların bir `srcs` klasörünün içinde olduğundan emin olun; `Makefile` ise repository'nin kökünde bulunmalıdır.

Repository'nin kökünde bir `Makefile` bulunduğundan emin olun.

Değerlendirmeye başlamadan önce terminalde şu komutu çalıştırın:

```bash
docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
```

Ardından, host'a bağlı volume veri dizinini kaldırmak için şu komutu çalıştırın (student_login yerine değerlendirilen öğrencinin login'ini yazın):

```bash
sudo rm -rf /home/student_login/data/*
```

`docker-compose.yml` dosyasını okuyun. İçinde `network: host` veya `links:` olmamalıdır. Aksi takdirde değerlendirme şimdi sona erer.

`docker-compose.yml` dosyasını okuyun. İçinde `network(s)` olmalıdır. Aksi takdirde değerlendirme sona erer.

`Makefile`'ı ve Docker'ın kullanıldığı tüm script'leri inceleyin. `--link` kullanılmamalıdır. Aksi takdirde değerlendirme şimdi sona erer.

`Dockerfile`'ları inceleyin. Herhangi birinin `ENTRYPOINT` bölümünde `tail -f` veya arka planda çalıştırılan herhangi bir komut görürseniz, değerlendirme şimdi sona erer. Aynı şekilde `bash` veya `sh` kullanılıyor ama bir script çalıştırmıyorsa (örn. `nginx & bash` veya `bash`) değerlendirme sona erer.

`Dockerfile`'ları inceleyin. Container'lar, Alpine veya Debian'ın sondan bir önceki kararlı sürümünden build edilmiş olmalıdır.

Entrypoint bir script ise (örn. `ENTRYPOINT ["sh", "my_entrypoint.sh"]`), hiçbir programın arka planda çalıştırılmadığından emin olun (örn. `nginx & bash`).

Repository'deki tüm script'leri inceleyin. Hiçbirinin sonsuz döngü çalıştırmadığından emin olun. Yasaklı komutlara bazı örnekler: `sleep infinity`, `tail -f /dev/null`, `tail -f /dev/random`.

`Makefile`'ı çalıştırın.

---

## Zorunlu bölüm

Bu proje, docker compose kullanarak farklı servislerden oluşan küçük bir altyapı kurmayı kapsamaktadır. Aşağıdaki tüm noktaların doğru olduğunu kontrol edin.

### Genel bakış etkinliği

Değerlendirilen öğrencinin size basit bir dilde şunları açıklaması gerekmektedir:

- Docker ve docker compose'un nasıl çalıştığı.
- Docker compose ile kullanılan bir Docker image'ı ile kullanılmayanın arasındaki fark.
- Docker'ın VM'lere kıyasla sağladığı fayda.
- Bu proje için gereken dizin yapısının önemi (subject dosyasında bir örnek verilmiştir).

---

### README kontrolü

- Repository'nin kökünde bir `README.md` dosyasının mevcut olduğundan emin olun.
- İlk satır gerekli formatı takip etmelidir: *"This project has been created as part of the 42 curriculum by \<login...\>"* (italik).
- README'nin en azından gerekli bölümleri içerdiğini kontrol edin: Description, Instructions, Resources (AI'nın nasıl kullanıldığının açıklaması dahil).
- Bu öğelerden herhangi biri eksikse, değerlendirme şimdi sona erer.

**[ ] Evet / [ ] Hayır**

---

### Dokümantasyon kontrolü

- Hem `USER_DOC.md` hem de `DEV_DOC.md` dosyalarının repository'nin kökünde mevcut olduğundan emin olun.
- `USER_DOC.md`, bir son kullanıcı veya yönetici için temel kullanım talimatları sağlamalıdır (projeyi başlatma/durdurma, web sitesine ve yönetim paneline erişme, kimlik bilgilerini yönetme, temel kontroller).
- `DEV_DOC.md`, geliştirici odaklı talimatlar sağlamalıdır (ön koşullar, kurulum, Makefile ve docker compose komutları, veri kalıcılığı).
- Bu dosyalardan herhangi biri eksik veya boşsa, inceleme şimdi sona erer.

**[ ] Evet / [ ] Hayır**

---

### Basit kurulum

- NGINX'e yalnızca 443 portu üzerinden erişilebildiğinden emin olun. Bunu yaptıktan sonra sayfayı açın.
- Bir SSL/TLS sertifikasının kullanıldığından emin olun.
- WordPress web sitesinin düzgün kurulduğundan ve yapılandırıldığından emin olun (Kurulum sayfasını görmemelisiniz). Erişmek için tarayıcınızda `https://login.42.fr` adresini açın; burada `login` değerlendirilen öğrencinin login'idir. Siteye `http://login.42.fr` üzerinden erişememelisiniz.
- Bir şey beklendiği gibi çalışmıyorsa, değerlendirme süreci şimdi sona erer.

**[ ] Evet / [ ] Hayır**

---

### Docker Temelleri

- `Dockerfile`'ları kontrol etmeye başlayın. Her servis için bir `Dockerfile` olmalıdır. Bunların boş dosyalar olmadığından emin olun. Durum böyle değilse veya bir `Dockerfile` eksikse, değerlendirme süreci sona erer.
- Değerlendirilen öğrencinin kendi `Dockerfile`'larını yazıp kendi Docker image'larını build ettiğinden emin olun; hazır olanları kullanmak veya DockerHub gibi servisleri kullanmak yasaktır.
- Her container'ın Alpine/Debian'ın sondan bir önceki kararlı sürümünden build edildiğinden emin olun. `FROM alpine:X.X.X` veya `FROM debian:XXXXX` veya başka bir yerel image ile başlamıyorsa değerlendirme süreci şimdi sona erer.
- Docker image'larının karşılık gelen servisleriyle aynı ada sahip olması gerekir. Aksi takdirde değerlendirme süreci şimdi sona erer.
- `Makefile`'ın tüm servisleri docker compose aracılığıyla kurduğundan emin olun. Bu, tüm container'ların docker compose kullanılarak build edildiği ve herhangi bir çöküşün yaşanmadığı anlamına gelir. Aksi takdirde değerlendirme sona erer.

**[ ] Evet / [ ] Hayır**

---

### Docker Network

- `docker-compose.yml` dosyasını kontrol ederek `docker-network`'ün kullanıldığından emin olun. Ardından bir ağın görünür olduğunu doğrulamak için `docker network ls` komutunu çalıştırın.
- Değerlendirilen öğrencinin size `docker-network`'ü basitçe açıklaması gerekmektedir.
- Yukarıdaki noktalardan herhangi biri doğru değilse, değerlendirme süreci şimdi sona erer.

**[ ] Evet / [ ] Hayır**

---

### SSL/TLS ile NGINX

- Bir `Dockerfile`'ın mevcut olduğundan emin olun.
- `docker compose ps` komutunu kullanarak container'ın oluşturulduğundan emin olun (gerekirse sudo yetkisiyle).
- Servise http (port 80) üzerinden erişmeyi deneyin ve bağlanamadığınızı doğrulayın.
- Tarayıcınızda `https://login.42.fr/` adresini açın; burada `login` değerlendirilen öğrencinin login'idir. Gösterilen sayfa yapılandırılmış WordPress web sitesi olmalıdır (WordPress Kurulum sayfasını görmemelisiniz).
- TLSv1.2 veya TLSv1.3 sertifikası kullanımı zorunludur ve gösterilmesi gerekir. Sertifikanın tanınmış olması gerekmez. Self-signed sertifika uyarısı çıkabilir.
- Yukarıdaki noktalardan herhangi biri açıkça açıklanmamışsa veya doğru değilse, değerlendirme süreci şimdi sona erer.

**[ ] Evet / [ ] Hayır**

---

### php-fpm ve volume'u ile WordPress

- Bir `Dockerfile`'ın mevcut olduğundan emin olun.
- `Dockerfile`'da NGINX olmadığından emin olun.
- `docker compose ps` komutunu kullanarak container'ın oluşturulduğundan emin olun (gerekirse sudo yetkisiyle).
- Bir Volume'un mevcut olduğundan emin olun: `docker volume ls` komutunu çalıştırın, ardından `docker volume inspect <volume adı>` komutunu çalıştırın. Standart çıktıdaki sonucun `/home/login/data` yolunu içerdiğini doğrulayın; burada `login` değerlendirilen öğrencinin login'idir.
- Mevcut WordPress kullanıcısını kullanarak yorum ekleyebildiğinizden emin olun.
- Yönetim paneline erişmek için yönetici (administrator) hesabıyla giriş yapın. Yönetici kullanıcı adı 'admin' veya 'Admin' içermemelidir (örn. admin, administrator, Admin-login, admin-123 vb.).
- Yönetim panelinden bir sayfayı düzenleyin. Web sitesinde sayfanın güncellendiğini doğrulayın.
- Yukarıdaki noktalardan herhangi biri doğru değilse, değerlendirme süreci şimdi sona erer.

**[ ] Evet / [ ] Hayır**

---

### MariaDB ve volume'u

- Bir `Dockerfile`'ın mevcut olduğundan emin olun.
- `Dockerfile`'da NGINX olmadığından emin olun.
- `docker compose ps` komutunu kullanarak container'ın oluşturulduğundan emin olun (gerekirse sudo yetkisiyle).
- Bir Volume'un mevcut olduğundan emin olun: `docker volume ls` komutunu çalıştırın, ardından `docker volume inspect <volume adı>` komutunu çalıştırın. Standart çıktıdaki sonucun `/home/login/data` yolunu içerdiğini doğrulayın; burada `login` değerlendirilen öğrencinin login'idir.
- Değerlendirilen öğrencinin size veritabanına nasıl giriş yapılacağını açıklayabilmesi gerekmektedir. Veritabanının boş olmadığını doğrulayın.
- Yukarıdaki noktalardan herhangi biri doğru değilse, değerlendirme süreci şimdi sona erer.

**[ ] Evet / [ ] Hayır**

---

### Kalıcılık (Persistence)!

Bu bölüm oldukça basittir. Virtual machine'i yeniden başlatmanız gerekmektedir. Yeniden başladıktan sonra, docker compose'u tekrar çalıştırın. Ardından her şeyin çalışır durumda olduğunu ve hem WordPress hem de MariaDB'nin yapılandırıldığını doğrulayın. WordPress web sitesinde daha önce yaptığınız değişiklikler hâlâ mevcut olmalıdır. Yukarıdaki noktalardan herhangi biri doğru değilse, değerlendirme süreci şimdi sona erer.

**[ ] Evet / [ ] Hayır**

---

### Yapılandırma değişikliği

Savunma sırasında, değerlendirici kişiden bir servisin yapılandırmasını değiştirmesini istemelidir (örneğin kullandığı port'u değiştirerek).

Değerlendirici, sistem tarafından kullanılmadığı sürece hangi servisin ve hangi yeni port'un seçileceğini belirlemekte serbesttir.

Değişiklikten sonra, değerlendirilen kişinin projeyi yeniden build edip yeniden başlatması gerekmektedir.

Servis, yeni yapılandırmayla erişilebilir ve işlevsel kalmaya devam etmelidir.

Değişiklik gerçekleştirilemiyorsa veya servis artık çalışmıyorsa, değerlendirme sona erer.

**[ ] Evet / [ ] Hayır**

---

## Bonus

Bu proje için bonus bölümü basit tutulmak üzere tasarlanmıştır. Her ek servis için bir `Dockerfile` yazılmalıdır. Dolayısıyla her servis kendi container'ı içinde çalışacak ve gerektiğinde kendine ayrılmış bir volume'a sahip olacaktır. Bonus bölümünü yalnızca zorunlu bölüm tamamen ve mükemmel biçimde tamamlanmışsa değerlendirin. Mükemmel, zorunlu bölümün tamamen tamamlanmış ve herhangi bir arıza olmaksızın çalışıyor olması anlamına gelir. Tüm zorunlu gereksinimleri geçememişseniz bonus bölümünüz hiç değerlendirilmeyecektir.

### Bonus listesi:

- WordPress web siteniz için önbelleği düzgün yönetmek amacıyla `redis cache` kurun.
- WordPress web sitenizin volume'una işaret eden bir `FTP server` container'ı kurun.
- PHP dışında istediğiniz bir dilde basit bir statik web sitesi oluşturun (evet, PHP hariçtir). Örneğin, bir showcase sitesi veya özgeçmişinizi sunan bir site.
- `Adminer` kurun.
- Faydalı olduğunu düşündüğünüz istediğiniz bir servis kurun. Savunma sırasında tercihini gerekçelendirmeniz gerekecektir.

Her onaylanan bonus için 1 puan ekleyin. Her ek servisin doğru uygulanmasını doğrulayın ve test edin. Serbest seçim servisi için, değerlendirilen öğrencinin nasıl çalıştığına ve neden faydalı olduğuna inandığına dair basit bir açıklama yapması gerekmektedir.

**0 (başarısız) ile 5 (mükemmel) arasında puanlayın.**

---

## Notlar

**Savunmaya karşılık gelen flag'i işaretlemeyi unutmayın.**

- [ ] Tamam
- [ ] Olağanüstü proje
- [ ] Boş çalışma
- [ ] Eksik çalışma
- [ ] Kopya
- [ ] Çöküş
- [ ] Kodu destekleyemiyor / açıklayamıyor

---

## Sonuç

Bu değerlendirme üzerine bir yorum bırakın (maksimum 2048 karakter).

---

*Değerlendirmeyi tamamla*
