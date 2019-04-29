"use strict";

$(document).ready(function() {

  let scroll_start = 0;
  let menuClass = 'containous-shrinked-menu';

    const modals = ["applyFormModal", "contactUsModal", "supportModal", "traefikeeTryItModal"]
    let showModal = name => {
        if (window.location.href.indexOf('#' + name) != -1)
            $('#' + name).modal('show');
    };

    modals.forEach(name => showModal(name));

  if ($("#containous-content section.traefikee-header").length > 0) {
      menuClass = 'traefikee-shrinked-menu';
  }

  $(document).scroll(function() {
    scroll_start = $(this).scrollTop();

    if (scroll_start > 30) {
      $('#containous-navbar').css('box-shadow', '0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19)');
      $('#containous-navbar').addClass('shrinked-menu');
      $('#containous-navbar').addClass(menuClass);

    } else {
      $('#containous-navbar').css('box-shadow', 'none');
      $('#containous-navbar').removeClass('shrinked-menu');
      $('#containous-navbar').removeClass(menuClass);
    }

    $('.count').each(function() {
      checkAnimation($(this), scroll_start);
    });
  });

  function isElementInViewport($elem, viewportTop) {
    const viewportBottom = viewportTop + $(window).height();
    const elemTop = Math.round($elem.offset().top);
    const elemBottom = elemTop + $elem.height();
    return ((elemTop < viewportBottom) && (elemBottom > viewportTop));
  }

  // Check if it's time to start the animation.
  function checkAnimation($elem, viewportTop) {
    if ($elem.hasClass('counting')) {
      return;
    }

    if (isElementInViewport($elem, viewportTop)) {
      $elem.addClass('counting');

      // Start the animation
      $elem.prop('Counter', 0).animate({
        Counter: $elem.text()
      }, {
        duration: 4000,
        easing: 'swing',
        step: function(now) {
          $elem.text(Math.ceil(now));
        }
      });
    }
  }

  var apis = {};
  apis["sf"] = "San Fransisco";
  apis["paris"] = "Paris";
  apis["ny"] = "New York";

  $.each(apis, callApi);

  function callApi (index, element) {
      
      $.ajax({
        url: window.location.href + index + "/api",
        contentType: "application/json",
        dataType: 'json',
        complete: function(result, status) {
          if (status != "success") {
            showFailure(index)
          } else {
            showSuccess(index, result.responseJSON.hostname);
          }

          setTimeout(function(){callApi(index, element)}, Math.floor(Math.random() * 150));
        }
      });
  }

  function showFailure(element) {
    removeBlock(element);
  }

  function showSuccess(element, hostname) {
    createBlockIfNeeded(element, apis[element], hostname);
    createHostLineIfNeeded(element, hostname);
    countSuccessOn(element, hostname);
  }

  function createBlockIfNeeded(blockId, blockTitle) {
    if ($( getBlockId(blockId, '#')).length == 0) {
      var divContent = "";
      divContent += '    <div id="'+getBlockId(blockId)+'" class="card d-inline-block" style="width: 18rem;">';
      divContent += '      <div class="card-header">' +blockTitle + '</div>';
      divContent += '<div class="card-body">';
      divContent += '<table class="container-fluid">';
      divContent += '<thead>';
      divContent += '<th>Server</th>';
      divContent += '<th>#Calls</th>';
      divContent += '</thead>';
      divContent += '<tbody id="'+getLinesHostCountersId(blockId)+'">';
      divContent += '</tbody>';
      divContent += '<tfoot>';
      divContent += '<th>Total</th>';
      divContent += '<th id="'+getBlockTotalCounterId(blockId)+'">0</th>';
      divContent += '</tfoot>';
      divContent += '</table>';
      divContent += '</div>';
      divContent += '</div>';

      $('#whoami-container').append(divContent);
    }
  }

  function removeBlock(blockId) {
    $(getBlockId(blockId, '#')).remove()
  }

  function countSuccessOn(block, host) {
    var counterValue = $(getBlockHostCounterId(block, host, '#')).html();
    counterValue++
    $(getBlockHostCounterId(block, host, '#')).html(counterValue);

    var total = 0;
    $(getBlockCounterClass(block, '.')).each(function () {
      total += parseInt($(this).html())
    })
    $(getBlockTotalCounterId(block, '#')).html(total)
  }

  function createHostLineIfNeeded(blockId, withHost) {
    if ($(getBlockHostCounterId(blockId, withHost, '#')).length == 0) {
      var trContent = "";
      trContent += '<tr>';
      trContent += '<td><i>'+withHost+'</i></td>';
      trContent += '<td id="'+getBlockHostCounterId(blockId, withHost)+'" class="'+getBlockCounterClass(blockId)+'">0</td>';
      trContent += '</tr>';

      var blockCountersId = getLinesHostCountersId(blockId, '#');
      $(blockCountersId).append(trContent);
    }
  }

  function getBlockId(blockId, prefix='') {
    return prefix + blockId + '-div';
  }

  function getBlockHostCounterId(blockId, host, prefix='') {
    return prefix + blockId + '-' + host + '-counter';
  }

  function getBlockCounterClass(blockId, prefix='') {
    return prefix + blockId + '-counter';
  }

  function getBlockTotalCounterId(blockId, prefix='') {
    return prefix + blockId + '-total';
  }

  function getLinesHostCountersId(blockId, prefix='') {
    return prefix + blockId + '-counters';
  }
});
