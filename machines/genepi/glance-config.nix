{
  theme = {
    light = true;
    background-color = "0 0 95";
    primary-color = "0 0 10";
    negative-color = "0 90 50";
  };
  pages = [
    {
      name = "Home";
      columns = [
        {
          size = "small";
          widgets = [
            {
              type = "calendar";
              first-day-of-week = "monday";
            }
            {
              type = "server-stats";
              servers = [
                {
                  type = "local";
                  name = "Genepi";
                }
              ];
            }
          ];
        }
        {
          size = "full";
          widgets = [
            {
              type = "search";
              autofocus = true;
            }
            {
              type = "monitor";
              cache = "1m";
              title = "Services";
              sites = [
                {
                  title = "Immich";
                  url = "https://images.home.rpqt.fr";
                  icon = "sh:immich";
                }
                {
                  title = "Grafana";
                  url = "https://grafana.home.rpqt.fr";
                  icon = "sh:grafana";
                }
                {
                  title = "FreshRSS";
                  url = "https://rss.home.rpqt.fr";
                  icon = "sh:freshrss";
                }
                {
                  title = "Syncthing";
                  url = "https://genepi.home.rpqt.fr/syncthing";
                  icon = "sh:syncthing";
                }
                {
                  title = "Actual Budget";
                  url = "https://actual.home.rpqt.fr";
                  icon = "sh:actual-budget";
                }
                {
                  title = "Gitea";
                  url = "https://git.turifer.dev";
                  icon = "sh:gitea";
                }
                {
                  title = "Pinchflat";
                  url = "https://pinchflat.home.rpqt.fr";
                  icon = "sh:pinchflat";
                }
              ];
            }
            {
              type = "monitor";
              cache = "1m";
              title = "Sites";
              sites = [
                {
                  title = "Lounge";
                  url = "https://lounge.home.rpqt.fr";
                  icon = "si:html5";
                }
                {
                  title = "Web corner";
                  url = "https://rpqt.fr";
                  icon = "si:html5";
                }
              ];
            }
            {
              type = "bookmarks";
              groups = [
                {
                  title = "Music";
                  links = [
                    {
                      title = "YouTube Music";
                      url = "https://music.youtube.com";
                    }
                    {
                      title = "Music for programming";
                      url = "https://musicforprogramming.net/latest/";
                    }
                  ];
                }
              ];
            }
          ];
        }
        {
          size = "small";
          widgets = [
            {
              type = "weather";
              location = "Grenoble, France";
              units = "metric";
              hour-format = "24h";
            }
            {
              type = "weather";
              location = "Saint-Michel-de-Maurienne, France";
              units = "metric";
              hour-format = "24h";
            }
          ];
        }
      ];
    }
    {
      name = "Feeds";
      columns = [
        {
          size = "small";
          widgets = [
            {
              type = "rss";
              title = "Blogs";
              limit = 10;
              collapse-after = 5;
              cache = "12h";
              feeds = [
                {
                  url = "https://rss.home.rpqt.fr/api/query.php?user=rpqt&t=74HfeLZ6Wu9h4MmjNR38Rz&f=rss";
                }
              ];
            }
            {
              type = "rss";
              title = "Status & Updates";
              limit = 3;
              cache = "12h";
              feeds = [
                {
                  url = "https://status.sr.ht/index.xml";
                }
              ];
            }
          ];
        }
        {
          size = "full";
          widgets = [
            {
              type = "group";
              widgets = [
                {
                  type = "hacker-news";
                }
                {
                  type = "lobsters";
                }
              ];
            }
            {
              type = "group";
              widgets = [
                {
                  type = "reddit";
                  subreddit = "selfhosted";
                  show-thumbnails = true;
                }
                {
                  type = "reddit";
                  subreddit = "homelab";
                  show-thumbnails = true;
                }
              ];
            }
            {
              type = "videos";
              channels = [
                "UCR-DXc1voovS8nhAvccRZhg"
                "UCsBjURrPoezykLs9EqgamOA"
              ];
            }
          ];
        }
        {
          size = "small";
          widgets = [
            {
              type = "releases";
              cache = "1d";
              repositories = [
                "glanceapp/glance"
              ];
            }
            {
              type = "custom-api";
              title = "Random Fact";
              cache = "6h";
              url = "https://uselessfacts.jsph.pl/api/v2/facts/random";
              template = ''
                <p class="size-h4 color-paragraph">{{ .JSON.String "text" }}</p>
              '';
            }
            {
              type = "custom-api";
              title = "Steam Specials";
              cache = "12h";
              url = "https://store.steampowered.com/api/featuredcategories?cc=us";
              template = ''
                <ul class="list list-gap-10 collapsible-container" data-collapse-after="5">
                {{ range .JSON.Array "specials.items" }}
                  <li>
                    <a class="size-h4 color-highlight block text-truncate" href="https://store.steampowered.com/app/{{ .Int "id" }}/">{{ .String "name" }}</a>
                    <ul class="list-horizontal-text">
                      <li>{{ div (.Int "final_price" | toFloat) 100 | printf "$%.2f" }}</li>
                      {{ $discount := .Int "discount_percent" }}
                      <li{{ if ge $discount 40 }} class="color-positive"{{ end }}>{{ $discount }}% off</li>
                    </ul>
                  </li>
                {{ end }}
                </ul>
              '';
            }
          ];
        }
      ];
    }
  ];
}
