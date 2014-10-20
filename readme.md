Surf Better Web Api
===================

##Service description

Provides aggregated data about various weather conditions impacted surf perfomance from different sources.

##Api


## [GET]/forecast/:code/:date

Returns weather conditions for particular spot in particular date

### Request parameters

+ :code - code of the spot
+ :date - date of the results, in format dd-MM-yyyy

Returns data in format

```
{
    date : "dd-MM-yyyy",
    type : "forecast",
    spot : {
        name : "beach name",
        code : "beach code",
        location : {
            country : {
                code : "country code",
                name : "country name"
            },
            region : "region name",
            city : "city name",
            geo : [lang(float), lat(float)]
        }
    },
    conditions : [
        {
            issuer : "windguru|surfgurur|msw|surf-forecast",
            type : "forecast",
            issuerReadDateTime : "dd-MM-yyyy:hh.MM", //when record was read from issuer
            dateTime : "dd-MM-yyyy:hh.MM",
            temperature : {
                air : {c : celsius(int), f : farengheit(int)}
                water : {c : celsius(int), f : farengheit(int)}
            },
            wind : {
                geo : "N|S|W|E|...",
                direction : "ON|OFF|CROSS", //onshore, offshore, cross
                speed : {
                    kph : int,
                    mph : int
                }
            },
            swell : "S|N",
            waves : {
                mediumHeight : float
                heightRange : [from(float), to(float)]
            }
        }
    ]
}
```