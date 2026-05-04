<template>
    <main>
        <div id="form-generator">
            <form action="POST" @submit.prevent="MakeStudyPlan()">
                <div>
                    <div>
                        <label for="subject">Fagområde:</label>
                        <input id="subject" v-model="inp.subject" type="text" placeholder="Samfunnskunnskap" required />
                    </div>
                    <div>
                        <label for="level">Nivå:</label>
                        <input id="level" v-model="inp.level" type="text" placeholder="Yrkesfag" required />
                    </div>
                    <div>
                        <label for="topic">Tema:</label>
                        <input id="topic" v-model="inp.topic" type="text" placeholder="Velferdsstaten" required />
                    </div>
                    <div>
                        <label for="exam_date">Dato for prøve / eksamen:</label>
                        <input id="exam_date" v-model="inp.exam_date" type="date" required />
                    </div>
                    <div>
                        <label for="test_type">Tema:</label>
                        <input id="test_type" v-model="inp.test_type" type="text" placeholder="fagsamtale" required />
                    </div>
                    <div>
                        <label for="language">Språk:</label>
                        <input id="language" v-model="inp.language" type="text" placeholder="Norsk" required />
                    </div>
                </div>
                <div><button type="submit"><span>lag study plan</span></button></div>
            </form>
            <br>
            <section v-if="data">
                <div>
                    <li>{{ data.study_plan.subject }}</li>
                    <li>{{ data.study_plan.level }}</li>
                    <li>{{ data.study_plan.topic }}</li>
                    <li>{{ data.study_plan.exam_date }}</li>
                    <li>{{ data.study_plan.test_type }}</li>
                    <li>{{ data.study_plan.generated_date }}</li>
                    <li>{{ data.study_plan.language }}</li>
                </div>
                <br>
                <div>
                    <h2>Flashcards:</h2>
                    <div v-for="(set, key) in data.study_plan.flashcards" :key="key">
                        <h3>Set: {{ key }}</h3>
                        <div v-for="(card, i) in set" :key="i" style=" margin-bottom: 1rem;">
                            <label for="{{ i }}">Spørsmål: {{ i + 1 }}</label>
                            <textarea name="{{ i }}" id="" v-model="card.question_text"
                                style="width: 100%; resize: vertical">
                            </textarea>
                            <br>
                            <label for="{{ i }}">svar:</label>
                            <textarea name="{{ i }}" id="" v-model="card.answer_text" style="width: 100%; resize: vertical;"
                                rows="5">do not remove this!
                            </textarea>

                        </div>
                    </div>
                </div>
                <br>
                <div>
                    <h2>Multiple Choice:</h2>
                    <div v-for="(mc, i) in data.study_plan.multiple_choice" :key="i">
                        <label for="{{ i }}">Spørsmål: {{ i }}</label>
                        <textarea name="{{ i }}" id="" v-model="mc.question_text" style="width: 100%; resize: vertical">
                        do not remove this!
                        </textarea>
                        <p>riktig svar: {{ mc.correct_answer_index + 1 }} </p>
                        <div v-for="(options, x) in mc.options" :key="x">
                            <label for="{{ x + 1 }}">{{ x + 1 }}</label>
                            <textarea name="{{ x + 1 }}" id="" v-model="mc.options[x]"
                                style="width: 100%; resize: vertical">do not remove this!</textarea>

                        </div>

                    </div>
                </div>
                <br>
                <div>
                    <p v-for="(day, i) in data.study_plan.days" :key="i">{{ day.scheduled_date }}: {{ day.focus_area }}</p>
                </div>
            </section>
            <!-- <pre>{{ data.study_plan.flashcards }}</pre>
            <pre>{{ data.study_plan.multiple_choice }}</pre> -->
            <button @click.prevent="postStudyPlan()" type="submit">Lag studieplan</button>
        </div>
    </main>
</template>
<script>
import axios from 'axios';
export default {
    data() {
        return {
            data:  {
  "study_plan": 
{
    "subject": "Sammfunnskunnskap",
    "grade": "Yrkesfag",
    "topic": "Velferdstaten",
    "exam_date": "05-05-2026",
    "test_type": "Skriftlig prøve",
    "test_type_id": 1,
    "generated_date": "28-04-2026",
    "language": "Norsk",
    "flashcards": [
        {
            "question_text": "Hva er en velferdsstat?",
            "answer_text": "En velferdsstat er et samfunn hvor staten tar ansvar for innbyggernes velferd gjennom offentlige tjenester som helsevesen, utdanning, trygd og sosiale støtteordninger.",
            "set_number": 1
        },
        {
            "question_text": "Hva er de tre hovedmodellene for velferdsstater?",
            "answer_text": "De tre hovedmodellene er: Den universelle/nordiske modellen, den konservative/kontinentaleuropeiske modellen, og den liberale/angloamerikanske modellen.",
            "set_number": 1
        },
        {
            "question_text": "Hva kjennetegner den nordiske velferdsmodellen?",
            "answer_text": "Den nordiske modellen kjennetegnes av universelle rettigheter, høy offentlig finansiering gjennom skatt, generøse velferdsordninger og likhet mellom kjønn og sosiale grupper.",
            "set_number": 1
        },
        {
            "question_text": "Når ble grunnlaget for den norske velferdsstaten lagt?",
            "answer_text": "Grunnlaget ble hovedsakelig lagt etter andre verdenskrig, fra 1945 og utover, med kraftig utbygging på 1960- og 1970-tallet.",
            "set_number": 1
        },
        {
            "question_text": "Hva er NAV?",
            "answer_text": "NAV (Nye arbeids- og velferdsetaten) er en statlig etat som forvalter arbeidsmarkedstiltak, pensjon, sykepenger, dagpenger og andre trygdeordninger i Norge.",
            "set_number": 1
        },
        {
            "question_text": "Hva betyr universelle rettigheter?",
            "answer_text": "Universelle rettigheter betyr at alle innbyggere har rett til de samme velferdsgodene uavhengig av inntekt, arbeid eller sosial status.",
            "set_number": 2
        },
        {
            "question_text": "Hvordan finansieres velferdsstaten i Norge?",
            "answer_text": "Velferdsstaten finansieres hovedsakelig gjennom skatter og avgifter, samt petroleumsinntekter gjennom Statens pensjonsfond utland.",
            "set_number": 2
        },
        {
            "question_text": "Hva er folketrygden?",
            "answer_text": "Folketrygden er Norges største velferdsordning som sikrer alle innbyggere økonomisk trygghet ved sykdom, arbeidsledighet, alderdom og uførhet.",
            "set_number": 2
        },
        {
            "question_text": "Nevn tre utfordringer for velferdsstaten",
            "answer_text": "Tre utfordringer er: en aldrende befolkning, økte helseutgifter og økonomisk bærekraft i fremtiden.",
            "set_number": 2
        },
        {
            "question_text": "Hva er trepartssamarbeidet?",
            "answer_text": "Trepartssamarbeidet er samarbeidet mellom staten, arbeidsgivere og arbeidstakere (fagforeninger) som har vært viktig for å utvikle velferdsstaten.",
            "set_number": 2
        },
        {
            "question_text": "Hva er sosial mobilitet?",
            "answer_text": "Sosial mobilitet er muligheten for individer til å bevege seg mellom sosiale klasser, ofte målt ved utdanning og inntekt. Velferdsstaten skal legge til rette for dette.",
            "set_number": 3
        },
        {
            "question_text": "Hva betyr velferdsstatsregnskapet?",
            "answer_text": "Velferdsstatsregnskapet viser balansen mellom inntekter (skatter) og utgifter til velferdsordninger, og er viktig for å vurdere økonomisk bærekraft.",
            "set_number": 3
        },
        {
            "question_text": "Hva er velferdsstatens omfordelingsfunksjon?",
            "answer_text": "Omfordelingsfunksjonen innebærer at ressurser overføres fra rike til fattige gjennom progressive skatter og sosiale støtteordninger for å redusere økonomisk ulikhet.",
            "set_number": 3
        },
        {
            "question_text": "Hva er en velferdskommune?",
            "answer_text": "Velferdskommunen er kommunenes rolle i velferdsstaten, der de har ansvar for tjenester som barnehager, grunnskole, pleie og omsorg.",
            "set_number": 3
        },
        {
            "question_text": "Hva er pensjonsreformen av 2011?",
            "answer_text": "Pensjonsreformen av 2011 innførte ny alderspensjon med mer fleksibel uttaksalder og pensjon basert på livsvarig inntekt for å sikre bærekraftige pensjoner.",
            "set_number": 3
        }
    ],
    "multiple_choice": [
        {
            "question_text": "Hvilken modell for velferdsstat følger Norge?",
            "options": [
                "Den liberale modellen",
                "Den nordiske modellen",
                "Den konservative modellen",
                "Den søreuropeiske modellen"
            ],
            "correct_answer_index": 1,
            "set_number": 1
        },
        {
            "question_text": "Hva er hovedfinansieringskilden for norsk velferdsstat?",
            "options": [
                "Private forsikringer",
                "Skatter og avgifter",
                "Utenlandske lån",
                "Donasjoner"
            ],
            "correct_answer_index": 1,
            "set_number": 1
        },
        {
            "question_text": "Når ble NAV opprettet?",
            "options": [
                "1945",
                "1967",
                "2006",
                "2015"
            ],
            "correct_answer_index": 2,
            "set_number": 1
        },
        {
            "question_text": "Hva er en av de største utfordringene for velferdsstaten?",
            "options": [
                "For mange unge i arbeid",
                "Aldrende befolkning",
                "For høy innvandring av arbeidskraft",
                "For lav skattlegging"
            ],
            "correct_answer_index": 1,
            "set_number": 1
        },
        {
            "question_text": "Hva menes med universelle rettigheter?",
            "options": [
                "Bare de som jobber får rettigheter",
                "Alle innbyggere har de samme rettighetene",
                "Bare personer over 67 år får rettigheter",
                "Bare norske statsborgere får rettigheter"
            ],
            "correct_answer_index": 1,
            "set_number": 1
        },
        {
            "question_text": "Hvilket år ble folketrygden innført i Norge?",
            "options": [
                "1945",
                "1957",
                "1967",
                "1975"
            ],
            "correct_answer_index": 2,
            "set_number": 2
        },
        {
            "question_text": "Hva er målet med velferdsstatens omfordelingspolitikk?",
            "options": [
                "Å øke forskjellene mellom rik og fattig",
                "Å redusere økonomisk ulikhet",
                "Å fjerne all beskatning",
                "Å privatisere offentlige tjenester"
            ],
            "correct_answer_index": 1,
            "set_number": 2
        },
        {
            "question_text": "Hvilken sektor har kommunene hovedansvar for i velferdsstaten?",
            "options": [
                "Forsvar og politi",
                "Utenrikspolitikk",
                "Barnehager og grunnskoler",
                "Toll og avgifter"
            ],
            "correct_answer_index": 2,
            "set_number": 2
        },
        {
            "question_text": "Hva er trepartssamarbeidet?",
            "options": [
                "Samarbeid mellom Norge, Sverige og Danmark",
                "Samarbeid mellom stat, arbeidsgivere og arbeidstakere",
                "Samarbeid mellom tre politiske partier",
                "Samarbeid mellom kommuner, fylker og stat"
            ],
            "correct_answer_index": 1,
            "set_number": 2
        },
        {
            "question_text": "Hva sikrer folketrygden?",
            "options": [
                "Gratis universitetsutdanning",
                "Økonomisk trygghet ved sykdom og alderdom",
                "Gratis bolig til alle",
                "Garantert jobb"
            ],
            "correct_answer_index": 1,
            "set_number": 2
        },
        {
            "question_text": "Hvilket fond sikrer fremtidig finansiering av velferdsstaten?",
            "options": [
                "Statens pensjonsfond utland",
                "Norges Bank",
                "Innovasjon Norge",
                "Folketrygdfondet"
            ],
            "correct_answer_index": 0,
            "set_number": 3
        },
        {
            "question_text": "Hva var hovedmålet med pensjonsreformen i 2011?",
            "options": [
                "Å senke pensjonsalderen til 62 år",
                "Å gjøre pensjonssystemet mer bærekraftig",
                "Å fjerne alderspensjon",
                "Å privatisere hele pensjonssystemet"
            ],
            "correct_answer_index": 1,
            "set_number": 3
        },
        {
            "question_text": "Hva kjennetegner sosial mobilitet i en velferdsstat?",
            "options": [
                "At alle tjener like mye",
                "At individer kan bevege seg mellom sosiale klasser",
                "At det ikke finnes forskjeller mellom mennesker",
                "At alle må ha samme yrke som foreldrene"
            ],
            "correct_answer_index": 1,
            "set_number": 3
        },
        {
            "question_text": "Hvilken type skattesystem støtter omfordeling i velferdsstaten?",
            "options": [
                "Flat skatt for alle",
                "Progressiv skatt",
                "Ingen skatt",
                "Bare bedriftsskatt"
            ],
            "correct_answer_index": 1,
            "set_number": 3
        },
        {
            "question_text": "Hva er en viktig verdi i den nordiske velferdsmodellen?",
            "options": [
                "Konkurranse mellom innbyggere",
                "Likhet og solidaritet",
                "Individuell eiendomsrett",
                "Privat eierskap av alt"
            ],
            "correct_answer_index": 1,
            "set_number": 3
        }
    ],
    "days": [
        {
            "scheduled_date": "28-04-2026",
            "focus_area": "Innføring i velferdsstaten",
            "tasks": {
                "1": {
                    "description": "Les gjennom notater om hva en velferdsstat er og de tre hovedmodellene for velferdsstater"
                },
                "2": {
                    "description": "Øv på grunnleggende begreper om velferdsstaten",
                    "type": "Flashcards",
                    "set_number": 1
                },
                "3": {
                    "description": "Test forståelsen av velferdsmodeller og finansiering",
                    "type": "Multiple_choices",
                    "set_number": 1
                }
            }
        },
        {
            "scheduled_date": "29-04-2026",
            "focus_area": "Den nordiske modellen og norsk velferdshistorie",
            "tasks": {
                "1": {
                    "description": "Studer den nordiske velferdsmodellen ogdens kjennetegn, samt norsk velferdshistorie etter 1945"
                },
                "2": {
                    "description": "Gå gjennom faktaspørsmål om universelle rettigheter og finansiering",
                    "type": "Flashcards",
                    "set_number": 2
                },
                "3": {
                    "description": "Øv på spørsmål om folketrygden og NAV",
                    "type": "Multiple_choices",
                    "set_number": 2
                }
            }
        },
        {
            "scheduled_date": "30-04-2026",
            "focus_area": "Velferdstatens organisering og institusjoner",
            "tasks": {
                "1": {
                    "description": "Les om NAV, folketrygden og kommunenes rolle i velferdsstaten"
                },
                "2": {
                    "description": "Repeter sentrale begreper om omfordeling og sosial mobilitet",
                    "type": "Flashcards",
                    "set_number": 3
                },
                "3": {
                    "description": "Test kunnskap om pensjonsfond og pensjonsreform",
                    "type": "Multiple_choices",
                    "set_number": 3
                }
            }
        },
        {
            "scheduled_date": "01-05-2026",
            "focus_area": "Utfordringer og finansiering av velferdsstaten",
            "tasks": {
                "1": {
                    "description": "Studer utfordringer som aldrende befolkning, helseutgifter og økonomisk bærekraft"
                },
                "2": {
                    "description": "Repeter alle hovedbegreper fra sett 1",
                    "type": "Flashcards",
                    "set_number": 1
                },
                "3": {
                    "description": "Øv på spørsmål om velferdsstatens utfordringer og organisering",
                    "type": "Multiple_choices",
                    "set_number": 1
                }
            }
        },
        {
            "scheduled_date": "02-05-2026",
            "focus_area": "Trepartssamarbeid og omfordeling",
            "tasks": {
                "1": {
                    "description": "Les om trepartssamarbeidet, omfordelingspolitikk og progressiv beskatning"
                },
                "2": {
                    "description": "Gå gjennom flashcards om folketrygden og velferdsordninger",
                    "type": "Flashcards",
                    "set_number": 2
                },
                "3": {
                    "description": "Test forståelsen av trepartssamarbeid og omfordeling",
                    "type": "Multiple_choices",
                    "set_number": 2
                }
            }
        },
        {
            "scheduled_date": "03-05-2026",
            "focus_area": "Pensjonsreform og fremtidig bærekraft",
            "tasks": {
                "1": {
                    "description": "Studer pensjonsreformen av 2011 og Statens pensjonsfond utland"
                },
                "2": {
                    "description": "Repeter alle begreper om sosial mobilitet og velferdsstatsregnskapet",
                    "type": "Flashcards",
                    "set_number": 3
                },
                "3": {
                    "description": "Øv på spørsmål om pensjon og fremtidig økonomi",
                    "type": "Multiple_choices",
                    "set_number": 3
                }
            }
        },
        {
            "scheduled_date": "04-05-2026",
            "focus_area": "Repetisjon og helhetlig forståelse",
            "tasks": {
                "1": {
                    "description": "Gjennomgå alle notater og lag et sammendrag av de viktigste punktene om velferdsstaten"
                },
                "2": {
                    "description": "Repeter alle flashcards fra alle sett for helhetlig oversikt",
                    "type": "Flashcards",
                    "set_number": 1
                },
                "3": {
                    "description": "Gjennomfør en full quiz med alle typer spørsmål",
                    "type": "Multiple_choices",
                    "set_number": 1
                }
            }
        },
        {
            "scheduled_date": "05-05-2026",
            "focus_area": "Eksamen - Skriftlig prøve",
            "tasks": {
                "1": {
                    "description": "Gjennomfør den skriftlige prøven i samfunnskunnskap om velferdsstaten. Husk å lese oppgavene nøye og strukturer svarene dine godt. Lykke til!"
                }
            }
        }
    ]
}
  
}

,
            inp: {
                subject: '',
                level: '',
                topic: '',
                exam_date: '',
                test_type: '',
                language: ''
            }
        }
    },
    methods: {
        async MakeStudyPlan() {
            const form = new FormData()
            form.append('subject', this.inp.subject)
            form.append('level', this.inp.level)
            form.append('topic', this.inp.topic)
            form.append('exam_date', this.inp.exam_date)
            form.append('test_type', this.inp.test_type)
            form.append('language', this.inp.language)
            try {
                const res = await axios.post('/api/study-plan/generate/', form)
                this.data = res.data
                console.log(this.data)
            }
            catch (error) {
                console.error(error)
            }
        },
        async postStudyPlan(){
            try{
                const res = await axios.post('/api/study-plan/save/', this.data)
                console.log(res.status)
            }catch(error){
                console.error(error)
            }
        }


    }
}
</script>

<style scoped>
main {
    /* grid-column: 1 / -1; */
    padding-top: 5rem;
    width: 100vw;
    box-sizing: border-box;

}

#form-generator {
    max-width: 100vw;
    margin: 0 auto;
    padding: 4rem;
}
</style>