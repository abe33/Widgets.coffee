(function() {
  var BUILDS, BuildUnit, TableBuilder, i, j;

  TableBuilder = (function() {

    function TableBuilder(options) {
      this.options = options;
    }

    TableBuilder.prototype.build = function() {
      var col, cols, colspan, context, hasColumnHeaders, hasRowHeaders, k, row, rows, table, td, th, tr, unit, v, widget, _i, _j, _k, _l, _len, _len2, _len3, _m, _ref, _ref2, _ref3, _ref4, _results, _results2;
      cols = (function() {
        _results = [];
        for (var _i = 0, _ref = this.options.cols - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
      rows = (function() {
        _results2 = [];
        for (var _j = 0, _ref2 = this.options.rows - 1; 0 <= _ref2 ? _j <= _ref2 : _j >= _ref2; 0 <= _ref2 ? _j++ : _j--){ _results2.push(_j); }
        return _results2;
      }).apply(this);
      hasColumnHeaders = this.options.columnHeaders != null;
      hasRowHeaders = this.options.rowHeaders != null;
      table = $("<table></table>");
      if (this.options.tableClass != null) table.addClass(this.options.tableClass);
      if (this.options.title != null) {
        colspan = this.options.cols;
        if (hasRowHeaders) colspan += 1;
        table.append($("<tr><th colspan ='" + colspan + "'                              class='table-header'>                          " + this.options.title + "                      </th></tr>"));
      }
      if (hasColumnHeaders) {
        tr = $("<tr></tr>");
        table.append(tr);
        if (hasRowHeaders) tr.append("<td></td>");
        context = {
          builder: this,
          table: table,
          tr: tr
        };
        for (_k = 0, _len = cols.length; _k < _len; _k++) {
          col = cols[_k];
          th = $("<th class='column-header'></th>");
          tr.append(th);
          context.col = col;
          context.th = th;
          th.text(this.options.columnHeaders.call(this, context));
        }
      }
      for (_l = 0, _len2 = rows.length; _l < _len2; _l++) {
        row = rows[_l];
        tr = $("<tr></tr>");
        table.append(tr);
        context = {
          builder: this,
          table: table,
          tr: tr,
          row: row
        };
        if (hasRowHeaders) {
          th = $("<th class='row-header'></th>");
          tr.append(th);
          context.th = th;
          th.text(this.options.rowHeaders.call(this, context));
        }
        for (_m = 0, _len3 = cols.length; _m < _len3; _m++) {
          col = cols[_m];
          td = $("<td></td>");
          tr.append(td);
          if (this.options.cls != null) {
            unit = new BuildUnit({
              cls: this.options.cls,
              args: this.options.args
            });
            widget = unit.build();
            widget.attach(td);
            context.widget = widget;
          }
          _ref3 = {
            td: td,
            col: col
          };
          for (k in _ref3) {
            v = _ref3[k];
            context[k] = v;
          }
          if ((_ref4 = this.options.cells) != null) _ref4.call(this, context);
        }
      }
      return table;
    };

    return TableBuilder;

  })();

  BuildUnit = (function() {

    function BuildUnit(options) {
      this.options = options;
    }

    BuildUnit.prototype.build = function() {
      var k, o, _base;
      o = this.construct(this.options.cls, this.options.args);
      if (o.set instanceof Function) {
        o.set(this.options.set);
      } else {
        for (k in this.options.set) {
          o[k] = this.options.set[k];
        }
      }
      if (typeof (_base = this.options).callback === "function") _base.callback(o);
      return o;
    };

    BuildUnit.prototype.construct = function(klass, args) {
      var f;
      f = BUILDS[args != null ? args.length : 0];
      return f(klass, args);
    };

    return BuildUnit;

  })();

  BUILDS = (function() {
    var _results;
    _results = [];
    for (i = 0; i <= 24; i++) {
      _results.push(new Function("return new arguments[0](" + (((function() {
        var _results2;
        _results2 = [];
        for (j = 0; 0 <= i ? j <= i : j >= i; 0 <= i ? j++ : j--) {
          if (j !== 0) _results2.push("arguments[1][" + (j - 1) + "]");
        }
        return _results2;
      })()).join(",")) + ");"));
    }
    return _results;
  })();

  this.BuildUnit = BuildUnit;

  this.TableBuilder = TableBuilder;

}).call(this);
