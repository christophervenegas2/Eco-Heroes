import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

Widget html = HtmlWidget(
  """
<p><strong>&iquest;Qu&eacute; necesito para convertirme en un EcoHeroe?</strong></p>
<p>Solo necesitas ser mayor de 18 a&ntilde;os, tener un smartphone y conexi&oacute;n a internet.</p>
<p><strong>&iquest;C&oacute;mo se realiza un desaf&iacute;o?</strong></p>
<p>Necesitas tener disponible un smartphone y conexi&oacute;n a internet.</p>
<p>Sigue las instrucciones de cada uno de nuestros desaf&iacute;os para recibir la recompensa correspondiente.</p>
<p><strong>&iquest;Por qu&eacute; debo entregar datos personales como mi RUT y mi direcci&oacute;n?</strong></p>
<p>Al convertirte en un EcoHeroe, podr&aacute;s realizar desaf&iacute;os que tienen como recompensa puntos de canje. Para transferirte estos puntos, necesitamos estos datos los cuales ser&aacute;n utilizados s&oacute;lo para estos fines.</p>
<p><strong>&iquest;C&oacute;mo recuperar mi contrase&ntilde;a?</strong></p>
<p>Siempre puedes recuperar tu contrase&ntilde;a haciendo clic sobre &ldquo;olvid&eacute; mi clave&rdquo; en acceso de usuarios. Un link de validaci&oacute;n ser&aacute; enviado a tu correo electr&oacute;nico. Si ingresaste mal tu correo electr&oacute;nico, debes escribirnos cuanto antes a contacto@ecoheroes.cl.</p>
<p><strong>&iquest;C&oacute;mo s&eacute; que EcoHeroes es una empresa seria y que realmente recibir&eacute; recompensas?</strong></p>
<p>Somos una empresa creada por emprendedores chilenos, apoyados y confiados por grandes empresas de nuestro pa&iacute;s. Nuestro compromiso es ser 100% transparentes de cara a todos nuestros EcoHeroes.</p>
<p><strong>&iquest;Qu&eacute; tipo de desaf&iacute;os puedo realizar con EcoHeroes?</strong></p>
<p>Existen principalmente 2 tipos de desaf&iacute;os.</p>
<ul>
<li>Desaf&iacute;os para realizar desde el hogar.</li>
<li>Desaf&iacute;os para realizar fuera del hogar, ya sea en una playa, un cerro, una calle, un parque, una plaza, orilla de r&iacute;o o lago, seg&uacute;n sea asignado por la app EcoHeroes.</li>
</ul>
<p><strong>&iquest;Qu&eacute; beneficios obtengo haciendo los desaf&iacute;os de EcoHeroes?</strong></p>
<p>La correcta realizaci&oacute;n de los desaf&iacute;os otorga recompensas a los usuarios que las realizan, obteniendo en todos los desaf&iacute;os la acumulaci&oacute;n de &ldquo;hojas de experiencia&rdquo;:</p>
<ol>
<li>Hojas de experiencia (): Por realizar correctamente cualquier tipo de desaf&iacute;o, el usuario siempre ganar&aacute; &ldquo;hojas de experiencia&rdquo;. A medida que el usuario acumule m&aacute;s &ldquo;hojas&rdquo;, podr&aacute; utilizarlas para los sorteos o canjes de productos ecofriendly de empresas asociadas con EcoHeroes, dependiendo del nivel y acumulacion de hojas de canje de cada usuario. Cada desaf&iacute;o otorgar&aacute; entre 5 y 25 hojas de experiencia, asignadas seg&uacute;n su nivel de complejidad.</li>
</ol>
<p>&nbsp;</p>
<p>Adicionalmente, los usuarios obtendr&aacute;n una de las siguientes tres opciones de recompensas:</p>
<ol>
<li>Cupones de descuento: Existen 2 tipos de cupones de descuento canjeables en la empresa que patrocina cada desaf&iacute;o. Pueden ser cupones valorados en montos en pesos, y en otros casos, cupones con un descuento expresados de forma porcentual. El usuario encontrar&aacute; en el s&iacute;mbolo &ldquo;?&rdquo; inclu&iacute;do en cada desaf&iacute;o, las respectivas condiciones de cada uno de los cupones para poder ser canjeados correctamente.</li>
<li>Cupones de plantaci&oacute;n de &aacute;rboles: Tenemos una serie de desaf&iacute;os que al ser realizados correctamente por los usuarios, estos recibir&aacute;n como recompensa un cup&oacute;n con un c&oacute;digo que ser&aacute; canjeable por cierta cantidad de &aacute;rboles, definido seg&uacute;n la dificultad del desaf&iacute;o y patrocinio de la empresa, para plantar a trav&eacute;s de la ONG One Tree Planted en su p&aacute;gina web.</li>
<li>Puntos de canje: Algunos desaf&iacute;os realizados ser&aacute;n recompensadas con puntos, los que luego el usuario podr&aacute; canjearlos por diversas giftcards, productos, servicios y experiencias de varias empresas, todas estas ofrecidas en la p&aacute;gina web de nuestra alianza con PuntosPoint (<a href="https://www.puntospoint.com/">https://www.puntospoint.com/</a>).</li>
</ol>
<p><strong>&iquest;Cu&aacute;nto valen los puntos?</strong></p>
<p>La equivalencia es muy sencilla: 700 puntos = \$1.000 canjeable/s en productos, experiencias y giftcards ofrecidas por PuntosPoint.</p>
<p><strong>&iquest;Por qu&eacute; hay desaf&iacute;os que no entregan puntos y por qu&eacute; deber&iacute;a realizarlos?</strong></p>
<p>Estos son desaf&iacute;os que ayudan al medio ambiente de forma voluntaria, es importante que los realices para que aprendas c&oacute;mo realizar correctamente un desaf&iacute;o y para que vayas adquiriendo experiencia como EcoHeroe.</p>
<p><strong>&iquest;Qu&eacute; sucede si acepto el desaf&iacute;o y luego no lo realizo en el tiempo asignado?</strong></p>
<p>Al aceptar el desaf&iacute;o, no podr&aacute;s seguir vi&eacute;ndolo como &ldquo;disponible&rdquo;, sino como &ldquo;en curso&rdquo;. Cada desaf&iacute;o tiene un n&uacute;mero limitado de cupos antes de que se acabe. Por ello, el hecho que aceptes un desaf&iacute;o y luego no lo realices, perjudica al resto de los usuarios que tambi&eacute;n quieren realizarlo. Para controlar esto, hemos decidido que cada desaf&iacute;o tiene un m&aacute;ximo de 7 d&iacute;as corridos para ser realizado y reportado.</p>
<p><strong>&iquest;Por qu&eacute; debo activar los servicios de localizaci&oacute;n en mi smartphone?</strong></p>
<p>Es necesario que tengas activado el servicio de localizaci&oacute;n para que puedas localizar cu&aacute;l es tu punto limpio/verde m&aacute;s cercano donde podr&aacute;s reciclar tus residuos (pl&aacute;stico, cart&oacute;n, vidrio, ropa, etc).</p>
<p><strong>&iquest;Cu&aacute;ndo puedo solicitar el canje de las recompensas?</strong></p>
<p>Los usuarios que hayan realizado desaf&iacute;os recompensados y luego que &eacute;stos hayan sido validados por el equipo de EcoHeroes, podr&aacute;n canjearlos seg&uacute;n las condiciones se&ntilde;aladas en cada recompensa.</p>
<ul>
<li>Cupones de descuento: EcoHeroes entregar&aacute; el cup&oacute;n de descuento ofrecido al usuario por la app dentro de 24hrs desde que el desaf&iacute;o fue realizado por el usuario y validado por EcoHeroes. La vigencia de canje del cup&oacute;n depender&aacute; de las condiciones ofrecidas por las empresas patrocinadoras, informaci&oacute;n que ser&aacute; comunicada al usuario a trav&eacute;s de la app.</li>
<li>Cupones de plantaci&oacute;n de &aacute;rboles: EcoHeroes entregar&aacute; el cup&oacute;n de plantaci&oacute;n de &aacute;rboles ofrecido al usuario por la app dentro de 24hrs desde que el desaf&iacute;o fue realizado por el usuario y validado por EcoHeroes. El canje del cup&oacute;n deber&aacute; ser realizado por el usuario a trav&eacute;s de la p&aacute;gina web de la fundaci&oacute;n One Tree Planted, <a href="https://onetreeplanted.org/products/plant-trees">https://onetreeplanted.org/products/plant-trees</a>, o bien, el usuario puede solicitar el canje a trav&eacute;s del equipo de EcoHeroes, escribi&eacute;ndonos a <a href="mailto:contacto@ecoheroes.cl">contacto@ecoheroes.cl</a>. Luego de canjeado el cup&oacute;n por &aacute;rboles en el lugar escogido entre las opciones ofrecidas por la ONG, el usuario recibir&aacute; un mail incluyendo un certificado con el detalle de su donaci&oacute;n.</li>
<li>Puntos de canje: EcoHeroes entregar&aacute; la cantidad de puntos ofrecidos al usuario por la app dentro de 24hrs desde que el desaf&iacute;o fue realizado por el usuario y validado por EcoHeroes. En la secci&oacute;n de su cuenta podr&aacute; ver los puntos acumulados a la fecha, pudiendo ser canjeados cuando estime conveniente en productos, servicios, experiencias y giftcards ofrecidas por PuntosPoint, empresa asociada a EcoHeroes. Los puntos acumulados podr&aacute;n ser canjeados dentro de 1 a&ntilde;o a partir de la fecha del &uacute;ltimo puntaje obtenido. Si el usuario no registr&oacute; nuevos desaf&iacute;os con recompensas en puntos dentro de 365 d&iacute;as, sus puntos acumulados quedar&aacute;n invalidados. En caso de canjear los puntos por giftcards, estas tendr&aacute;n una vigencia de un a&ntilde;o y medio (547 d&iacute;as) desde la fecha en que fueron canjeadas por el usuario, esto es, desde la fecha en que se descontaron los puntos desde la cuenta del usuario para obtener la giftcard de cierto monto en pesos de un comercio asociado.</li>
<li>Hojas de experiencia (): Cada cierto tiempo, EcoHeroes realizar&aacute; sorteos de diversos productos que son amigables con el medio ambiente, por los cuales los usuarios podr&aacute;n concursar a cambio de sus &ldquo;hojas de experiencia&rdquo; que tengan acumulados, siempre que cumplan con el m&iacute;nimo requerido.</li>
</ul>
<p>&nbsp;</p>
<p><strong>&iquest;Alguna otra pregunta? </strong></p>
<p>Si tienes cualquier otra duda o comentario, favor escr&iacute;benos a <a href="mailto:contacto@ecoheroes.cl">contacto@ecoheroes.cl</a> Puedes escribirnos tambi&eacute;n directamente a los fundadores de EcoHeroes quienes responder&aacute;n personalmente: <a href="mailto:tomas.alonso@ecoheroes.cl">tomas.alonso@ecoheroes.cl</a> o <a href="mailto:jorge.alonso@ecoheroes.cl">jorge.alonso@ecoheroes.cl</a>.</p>
      """,
);
