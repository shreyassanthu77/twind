// deno-lint-ignore-file no-import-prefix
import $ from "jsr:@david/dax@0.44.1";
import { parse, stringify } from "jsr:@std/yaml@1.0.10";
import {
  parse as parseSemver,
  format,
  increment,
  type SemVer,
} from "jsr:@std/semver@1.0.7";

// make sure there are no uncommitted changes
if ((await $`git status --porcelain`.text()).length > 0) {
  console.log(
    "There are uncommitted changes, please commit them before bumping.",
  );
  // Deno.exit(1);
}

const twindPubspec = (await parse(
  await Deno.readTextFile("packages/twind/pubspec.yaml"),
)) as {
  version: string;
};
const twindVersion = twindPubspec.version;
const twindGeneratorPubspec = (await parse(
  await Deno.readTextFile("packages/twind_generator/pubspec.yaml"),
)) as {
  version: string;
};
const twindGeneratorVersion = twindGeneratorPubspec.version;
console.log(`Current Twind version: ${twindVersion}`);
console.log(`Current Twind Generator version: ${twindGeneratorVersion}`);
if (twindVersion !== twindGeneratorVersion) {
  console.log(
    "Twind and Twind Generator versions do not match, please update both.",
  );
  Deno.exit(1);
}

const parsedVersion = parseSemver(twindVersion);
let newVersion: SemVer;
switch (prompt("patch(p), minor(m), major(M)?", "p")) {
  case "p":
  case "patch":
    newVersion = increment(parsedVersion, "patch");
    break;
  case "m":
  case "minor":
    newVersion = increment(parsedVersion, "minor");
    break;
  case "M":
  case "major":
    newVersion = increment(parsedVersion, "major");
    break;
  default:
    console.log("Invalid version bump type, please try again.");
    Deno.exit(1);
}
const bumpedVersion = format(newVersion);
console.log(`New Twind version: ${bumpedVersion}`);

twindPubspec.version = bumpedVersion;
twindGeneratorPubspec.version = bumpedVersion;
await Deno.writeTextFile(
  "packages/twind/pubspec.yaml",
  stringify(twindPubspec),
);
await Deno.writeTextFile(
  "packages/twind_generator/pubspec.yaml",
  stringify(twindGeneratorPubspec),
);

if (confirm("Do you want to commit the changes and tag the release?")) {
  await $`git add packages/twind/pubspec.yaml packages/twind_generator/pubspec.yaml`;
  await $`git commit -m "chore(release): ${bumpedVersion}"`;
  await $`git tag v${bumpedVersion}`;
  if (confirm("Do you want to push the changes and tag?")) {
    await $`git push`;
    await $`git push --tags`;
  }
}
