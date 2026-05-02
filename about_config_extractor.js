(async () => {
    // Click "Accept Risk and Continue"
    const warningButton = document.getElementById("warningButton");
    if (warningButton !== null) {
      warningButton.click();
    }

    // Click "Show All"
    document.getElementById("show-all").click();

    let allPrefs = [];
    const prefsTable = document.getElementById("prefs");
    for (const row of prefsTable.children) {
        // Ignore modified prefs
        if (row.classList.contains("has-user-value")) {
            continue;
        }

        const pref = row.children[0].textContent;
        const value = row.children[1].textContent;

        const prefString =
          /^(true|false|[0-9]+)$/.test(value)
            ? `pref("${pref}", ${value});`
            : `pref("${pref}", "${value}");`;

        allPrefs.push(prefString);
    }

    await navigator.clipboard.writeText(allPrefs.join("\n"));
    alert("All prefs copied to clipboard.");
    // console.log(allPrefs.join("\n"));
})();
