<h2>Meeting 18 settembre</h2>
Avevi proposto un approccio in cui:
<ul>
  <li>Risolvevi le collisioni solo nell'ultimo segmento di ogni traiettoria, perché simulava il caso in cui i robot arrivassero alla fine allineandosi</li>
  <li>In questi segmenti, tra tutte le collisioni, cercavi il robot più lontano dal goal al momento della collisione</li>
  <li>Ritardavi questo robot di 1 secondo, e così via iterativamente per tutti i robot in collisione, finché tutte le collisioni non erano risolte</li>
</ul>

Per esempio in questo caso:
![warehouse](https://github.com/user-attachments/assets/d00d7ee6-945a-4019-8f8e-2e1f318740d4)

Il Robot blu sta più lontano rispetto al rosso e quindi viene ritardato di 1 secondo.
